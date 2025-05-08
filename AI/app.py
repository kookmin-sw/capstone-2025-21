import os
import json
import uuid
import numpy as np
from fastapi import FastAPI, HTTPException, File, UploadFile, Form
from typing import List, Optional
import torch
from paddleocr import PaddleOCR
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

# 번역을 위한 Translator 초기화
from googletrans import Translator
translator = Translator()
# 언어 매핑: 사용자 국적에 따른 언어 코드
langs = {"en": "en", "ch": "zh-cn", "jp": "ja"}

# 1) 작업 디렉터리 결정
script_dir = os.path.dirname(os.path.abspath(__file__))

# 2) 사전 계산된 데이터 경로 설정
embeddings_path = os.path.join(script_dir, "menu_embeddings.npy")
metadata_path   = os.path.join(script_dir, "menu_metadata.json")
translated_path = os.path.join(script_dir, "ingredients_translated.json")
related_path    = os.path.join(script_dir, "allergy_related_ingredients.json")
#index_path      = os.path.join(script_dir, "menu_name_index.json")

# 3) 임베딩·메타데이터·이름→인덱스 맵 로드
menu_embeddings = np.load(embeddings_path)
with open(metadata_path, "r", encoding="utf-8") as f_meta:
    menu_metadata = json.load(f_meta)
with open(translated_path, "r", encoding="utf-8") as f:
    allergy_translation = json.load(f)
with open(related_path, "r", encoding="utf-8") as f:
    allergy_map = json.load(f)
'''
with open(index_path, "r", encoding="utf-8") as f_idx:
    name_to_index = json.load(f_idx)
'''
menu_names = [item["menu_name"]["ko"] for item in menu_metadata]

# reverse lookup table을 만들어 빠른 매칭
ingredient_to_allergy = {}
for allergy, ingredients in allergy_map.items():
    for ing in ingredients:
        ingredient_to_allergy[ing] = allergy

ko_to_multilang = {item["ko"]: item for item in allergy_translation}

def translate_allergens(allergen_list, lang_code="en"):
    translated = []
    for allergen in allergen_list:
        item = ko_to_multilang.get(allergen)
        if item:
            translated.append(item.get(lang_code, allergen))
        else:
            translated.append(allergen)  # 못 찾으면 원문 유지
    return translated

# 4) OCR 및 임베딩 모델 초기화
ocr_model = PaddleOCR(use_angle_cls=True, lang="korean")
emb_model = SentenceTransformer("paraphrase-multilingual-mpnet-base-v2")

app = FastAPI()

@app.post("/analyze")
async def analyze(
    imagePath: str = Form(...),
    userId: int = Form(...),
    nationality: str = Form(...),
    favoriteFoods: str = Form("[]"),   # JSON string, e.g. '["비빔밥","불고기"]'
    allergies: str = Form("[]"),       # JSON string, e.g. '["땅콩"]'
    top_k: int = Form(5)
):
    """
    메뉴판 이미지와 사용자 정보를 받아:
    1) OCR로 메뉴명 추출
    2) 메뉴명-메타데이터 매칭
    3) 사용자 취향 임베딩 및 유사도 계산
    4) 알러지 제외 후 top_k 메뉴 추천
    """
    '''
    # A) OCR 처리를 위한 임시 파일 저장
    temp_fname = f"temp_{uuid.uuid4().hex}.jpg"
    temp_path = os.path.join(script_dir, temp_fname)
    with open(temp_path, "wb") as tmp:
        tmp.write(await image.read())
    '''

    # B) OCR: 메뉴명 추출
    ocr_result = ocr_model.ocr(imagePath, cls=True)
    scanned_lines = [(line[1][0], line[0]) for line in ocr_result[0]]

    # 임시 파일 삭제
    #os.remove(temp_path)

    # C) 유효한 메뉴명 필터링
    dest_lang = langs.get(nationality, "ko")
    seen = set()
    valid_scanned = []
    all_menu_items = []
    user_allergy_set = set(json.loads(allergies))
    for name, bbox in scanned_lines:
        if name in menu_names and name not in seen:
            matched_allergies = set()
            idx = menu_names.index(name)
            item = menu_metadata[idx]
            ingredients_str = item.get("ingredients", {}).get("ko", "")
            ing_list = [i.strip() for i in ingredients_str.split(",") if i.strip()]
            # 알러지 검사
            for ing in ingredient_to_allergy:
                if ing in ing_list:
                    matched_allergies.add(ingredient_to_allergy[ing])
            user_matched_allergies = matched_allergies & user_allergy_set
            # 메뉴명 번역
            if dest_lang != "ko":
                try:
                    translated_name = translator.translate(name, dest=dest_lang).text
                except Exception:
                    translated_name = name # 번역 실패 시 그대로 사용
            else:
                translated_name = name
            valid_scanned.append((idx, translated_name, bbox, bool(user_matched_allergies)))
            user_matched_allergies_translated = translate_allergens(user_matched_allergies, lang_code=nationality)
            
            seen.add(name)
            all_menu_items.append({
                "menu_name": translated_name,
                "has_allergy": bool(user_matched_allergies_translated),
                "allergy_types": user_matched_allergies_translated,
                "bbox": bbox
            })
    if not valid_scanned:
        raise HTTPException(status_code=400, detail="No valid menu names extracted")

    # D) 사용자 취향 정보 파싱
    fav_list = json.loads(favoriteFoods)

    # E) 스캔된 메뉴 임베딩 수집
    scanned_idxs = [idx for idx, _, _, _ in valid_scanned]
    scanned_embs = menu_embeddings[scanned_idxs]

    # F) 사용자 임베딩 계산
    if fav_list:
        user_emb = emb_model.encode([" ".join(fav_list)])[0]
    else:
        user_emb = np.mean(scanned_embs, axis=0)
    user_emb = user_emb.astype(np.float32)

    # G) 스캔된 메뉴와 유사도 계산
    sims = cosine_similarity(user_emb.reshape(1, -1), scanned_embs)[0]
    # 인덱스별 유사도 쌍 생성
    scored = list(zip(valid_scanned, sims))
    # 유사도 내림차순 정렬
    scored.sort(key=lambda x: x[1], reverse=True)

    # H) 알러지 제외 후 추천 생성
    recs = []
    for (idx, name, bbox, has_allergy), score in scored:
        # 알러지 필터링
        if has_allergy:
            continue
        recs.append({
            "menu_name": name,
            "similarity": float(score)
        })
        if len(recs) >= top_k:
            break

    return {"recommendations": recs}


# New endpoint to return all menu items with location and allergy info
@app.post("/analyze/menu")
async def analyze_menu(
    imagePath: str = Form(...),
    userId: int = Form(...),
    nationality: str = Form(...),
    favoriteFoods: str = Form("[]"),
    allergies: str = Form("[]"),
    top_k: int = Form(5)
):
    """
    FastAPI endpoint to return all menu items with location and allergy info.
    """
    # OCR and scanning
    ocr_result = ocr_model.ocr(imagePath, cls=True)
    scanned_lines = [(line[1][0], line[0]) for line in ocr_result[0]]

    dest_lang = langs.get(nationality, "ko")
    seen = set()
    all_menu_items = []
    user_allergy_set = set(json.loads(allergies))
    for name, bbox in scanned_lines:
        if name in menu_names and name not in seen:
            matched_allergies = set()
            idx = menu_names.index(name)
            item = menu_metadata[idx]
            ingredients_str = item.get("ingredients", {}).get("ko", "")
            ing_list = [i.strip() for i in ingredients_str.split(",") if i.strip()]
            # map ingredients to allergies
            for ing in ingredient_to_allergy:
                if ing in ing_list:
                    matched_allergies.add(ingredient_to_allergy[ing])
            user_matched_allergies = matched_allergies & user_allergy_set
            # translate menu_name
            if dest_lang != "ko":
                try:
                    translated_name = translator.translate(name, dest=dest_lang).text
                except Exception:
                    translated_name = name
            else:
                translated_name = name
            # translate allergy types
            allergy_types_translated = translate_allergens(user_matched_allergies, lang_code=nationality)
            seen.add(name)
            all_menu_items.append({
                "menu_name": translated_name,
                "bbox": bbox,
                "has_allergy": bool(allergy_types_translated),
                "allergy_types": allergy_types_translated
            })
    if not all_menu_items:
        raise HTTPException(status_code=400, detail="No valid menu names extracted")
    return {"menu_items": all_menu_items}