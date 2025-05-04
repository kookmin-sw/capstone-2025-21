import os
import json
import uuid
import numpy as np
from fastapi import FastAPI, HTTPException, File, UploadFile, Form
from typing import List, Optional
from paddleocr import PaddleOCR
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

# 번역을 위한 Translator 초기화
from googletrans import Translator
translator = Translator()
# 언어 매핑: 사용자 국적에 따른 언어 코드
langs = {"한국어": "ko", "영어": "en", "중국어": "zh-cn", "일본어": "ja"}

# 1) 작업 디렉터리 결정
script_dir = os.path.dirname(os.path.abspath(__file__))

# 2) 사전 계산된 데이터 경로 설정
embeddings_path = os.path.join(script_dir, "menu_embeddings.npy")
metadata_path   = os.path.join(script_dir, "menu_metadata.json")
index_path      = os.path.join(script_dir, "menu_name_index.json")

# 3) 임베딩·메타데이터·이름→인덱스 맵 로드
menu_embeddings = np.load(embeddings_path)
with open(metadata_path, "r", encoding="utf-8") as f_meta:
    menu_metadata = json.load(f_meta)
with open(index_path, "r", encoding="utf-8") as f_idx:
    name_to_index = json.load(f_idx)

# 4) OCR 및 임베딩 모델 초기화
ocr_model = PaddleOCR(use_angle_cls=True, lang="korean")
emb_model = SentenceTransformer("paraphrase-multilingual-mpnet-base-v2")

app = FastAPI()

@app.post("/analyze")
async def analyze(
    image: UploadFile = File(...),
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
    # A) OCR 처리를 위한 임시 파일 저장
    temp_fname = f"temp_{uuid.uuid4().hex}.jpg"
    temp_path = os.path.join(script_dir, temp_fname)
    with open(temp_path, "wb") as tmp:
        tmp.write(await image.read())

    # B) OCR: 메뉴명 추출
    ocr_result = ocr_model.ocr(temp_path, cls=True)
    scanned_lines = [line[1][0] for line in ocr_result]

    # 임시 파일 삭제
    os.remove(temp_path)

    # C) 유효한 메뉴명 필터링
    valid_scanned = [name for name in scanned_lines if name in name_to_index]
    if not valid_scanned:
        raise HTTPException(status_code=400, detail="No valid menu names extracted")

    # D) 사용자 취향·알러지 정보 파싱
    fav_list = json.loads(favoriteFoods)
    allergy_set = set(json.loads(allergies))

    # E) 스캔된 메뉴 임베딩 수집
    scanned_idxs = [name_to_index[name] for name in valid_scanned]
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
    scored = list(zip(scanned_idxs, sims))
    # 유사도 내림차순 정렬
    scored.sort(key=lambda x: x[1], reverse=True)

    # H) 알러지 제외 후 추천 생성
    recs = []
    for idx, score in scored:
        item = menu_metadata[idx]
        ingredients_str = item.get("ingredients", {}).get("ko", "")
        ing_list = [i.strip() for i in ingredients_str.split(",") if i.strip()]
        # 알러지 필터링
        if allergy_set and any(allergen in ing_list for allergen in allergy_set):
            continue
        recs.append({
            "menu_name": item.get("menu_name", {}).get("ko", ""),
            "ingredients": ing_list,
            "similarity": float(score)
        })
        if len(recs) >= top_k:
            break

    # I) 메뉴명을 사용자 언어로 번역
    dest_lang = langs.get(nationality, "ko")
    translated_recs = []
    for rec in recs:
        name = rec["menu_name"]
        if dest_lang != "ko":
            translated_name = translator.translate(name, dest=dest_lang).text
        else:
            translated_name = name
        rec["menu_name"] = translated_name
        translated_recs.append(rec)
    recs = translated_recs

    return {"recommendations": recs}