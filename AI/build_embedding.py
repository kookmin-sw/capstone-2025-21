# build_embeddings.py
import json
import numpy as np
import os
from sentence_transformers import SentenceTransformer

def build_and_save_embeddings(
    json_path: str = None,
    embeddings_path: str = 'menu_embeddings.npy',
    metadata_path: str = 'menu_metadata.json'
):
    # 기본적으로 스크립트 위치를 기준으로 경로 설정
    script_dir = os.path.dirname(os.path.abspath(__file__))
    if json_path is None:
        json_path = os.path.join(script_dir, 'translated_menu_structured.json')

    # 1) 사전 학습된 S-BERT 모델 로드
    model = SentenceTransformer('paraphrase-multilingual-mpnet-base-v2')

    # 2) JSON에서 메뉴 데이터 로드
    with open(json_path, 'r', encoding='utf-8') as f:
        menu_db = json.load(f)

    # 3) 메뉴명과 재료를 결합하여 텍스트 리스트 생성
    texts = [f"{item['menu_name']['ko']}: {item['ingredients']['ko']}" for item in menu_db]

    # 4) 임베딩 생성
    embeddings = model.encode(texts, batch_size=64, show_progress_bar=True)
    embeddings = np.array(embeddings, dtype=np.float32)

    # 5) 결과 저장
    np.save(os.path.join(script_dir, embeddings_path), embeddings)
    with open(os.path.join(script_dir, metadata_path), 'w', encoding='utf-8') as f:
        json.dump(menu_db, f, ensure_ascii=False, indent=2)

    print(f"[build_embeddings] Saved {len(menu_db)} embeddings to {embeddings_path}")
    print(f"[build_embeddings] Saved metadata to {metadata_path}")

if __name__ == '__main__':
    build_and_save_embeddings()


# app.py (FastAPI 서버)
from fastapi import FastAPI
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer
import numpy as np
import json
from sklearn.metrics.pairwise import cosine_similarity

class UserRequest(BaseModel):
    favorites: list[str]
    allergies: list[str]
    top_k: int = 5

app = FastAPI()

# 서버 시작 시 한 번만 로드
model = SentenceTransformer('paraphrase-multilingual-mpnet-base-v2')
# 스크립트 기준 경로
import os
script_dir = os.path.dirname(os.path.abspath(__file__))
embeddings = np.load(os.path.join(script_dir, 'menu_embeddings.npy'))
with open(os.path.join(script_dir, 'menu_metadata.json'), 'r', encoding='utf-8') as f:
    menu_db = json.load(f)

@app.post('/recommend')
async def recommend(req: UserRequest):
    # 1) 사용자 취향 임베딩 생성
    user_emb = model.encode([' '.join(req.favorites)])[0].astype(np.float32)

    # 2) 코사인 유사도 계산
    sims = cosine_similarity([user_emb], embeddings)[0]
    idxs = sims.argsort()[::-1]

    # 3) 알러지 필터링 및 상위 결과 선택
    results = []
    for idx in idxs:
        item = menu_db[idx]
        ing = item['ingredients']['ko']
        if any(allergen in ing for allergen in req.allergies):
            continue
        results.append({
            'menu_name': item['menu_name'],
            'similarity': float(sims[idx])
        })
        if len(results) >= req.top_k:
            break

    return {'recommendations': results}
