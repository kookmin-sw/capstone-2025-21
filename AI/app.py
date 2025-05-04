import os
import json
import uuid
import numpy as np
from fastapi import FastAPI, HTTPException
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

def _process_image(temp_path: str, fav_list: List[str], allergy_set: set, nationality: str, top_k: int):
    # OCR 수행
    ocr_result = ocr_model.ocr(temp_path, cls=True)
    scanned_lines = [(line[1][0], line[0]) for line in ocr_result]
    # 유효한 메뉴명 필터링
    seen = set()
    valid_scanned = []
    for name, bbox in scanned_lines:
        if name in name_to_index and name not in seen:
            idx = name_to_index[name]
            valid_scanned.append((idx, name, bbox))
            seen.add(name)
    if not valid_scanned:
        raise HTTPException(status_code=400, detail="No valid menu names extracted")
    # 임베딩 및 사용자 임베딩 계산
    scanned_idxs = [idx for idx, _, _ in valid_scanned]
    scanned_embs = menu_embeddings[scanned_idxs]
    if fav_list:
        user_emb = emb_model.encode([" ".join(fav_list)])[0]
    else:
        user_emb = np.mean(scanned_embs, axis=0)
    user_emb = user_emb.astype(np.float32)
    # 유사도 계산
    sims = cosine_similarity(user_emb.reshape(1, -1), scanned_embs)[0]
    scored = list(zip(valid_scanned, sims))
    scored.sort(key=lambda x: x[1], reverse=True)
    # 추천 생성
    recs = []
    for (idx, name, bbox), score in scored:
        item = menu_metadata[idx]
        ingredients_str = item.get("ingredients", {}).get("ko", "")
        ing_list = [i.strip() for i in ingredients_str.split(",") if i.strip()]
        if allergy_set and any(allergen in ing_list for allergen in allergy_set):
            continue
        recs.append({
            "menu_name": item.get("menu_name", {}).get("ko", ""),
            "ingredients": ing_list,
            "similarity": float(score),
            "bbox": bbox
        })
        if len(recs) >= top_k:
            break
    # 번역 처리
    dest_lang = langs.get(nationality, "ko")
    for rec in recs:
        name = rec["menu_name"]
        if dest_lang != "ko":
            try:
                rec["menu_name"] = translator.translate(name, dest=dest_lang).text
            except:
                rec["menu_name"] = name
    return recs

import httpx
from pydantic import BaseModel

class AnalyzeRequest(BaseModel):
    image_url: str
    userId: int
    nationality: str
    favoriteFoods: List[str] = []
    allergies: List[str] = []
    top_k: int = 5

@app.post("/analyze")
async def analyze(req: AnalyzeRequest):
    """
    JSON 바디로 이미지 URL과 사용자 정보를 받아:
    1) 이미지 다운로드
    2) OCR로 메뉴명 추출
    3) 메뉴명-메타데이터 매칭
    4) 사용자 취향 임베딩 및 유사도 계산
    5) 알러지 제외 후 top_k 메뉴 추천
    6) 메뉴명 번역
    """
    # A) 이미지 다운로드 및 임시 파일 저장
    image_bytes = httpx.get(req.image_url).content
    temp_fname = f"temp_{uuid.uuid4().hex}.jpg"
    temp_path = os.path.join(script_dir, temp_fname)
    with open(temp_path, "wb") as tmp:
        tmp.write(image_bytes)

    # B~I) 추천 로직 호출
    recs = _process_image(temp_path, req.favoriteFoods, set(req.allergies), req.nationality, req.top_k)

    # 임시 파일 삭제
    os.remove(temp_path)

    return {"recommendations": recs}
application = app