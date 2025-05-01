import os
import json
import numpy as np
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

# Set paths for data files
script_dir = os.path.dirname(os.path.abspath(__file__))
embeddings_path = os.path.join(script_dir, "menu_embeddings.npy")
metadata_path = os.path.join(script_dir, "menu_metadata.json")
name_index_path = os.path.join(script_dir, "menu_name_index.json")

# Load precomputed menu embeddings
menu_embeddings = np.load(embeddings_path)

# Load menu metadata
with open(metadata_path, "r", encoding="utf-8") as f:
    menu_metadata = json.load(f)

# Load menu name-to-index map
with open(name_index_path, "r", encoding="utf-8") as f:
    name_to_index = json.load(f)

# Load sentence transformer model for user embedding
model = SentenceTransformer('jhgan/ko-sroberta-multitask')

app = FastAPI()

class RecommendRequest(BaseModel):
    scanned: List[str]
    favorites: Optional[List[str]] = []
    allergies: Optional[List[str]] = []
    top_k: Optional[int] = 5

@app.post("/recommend")
def recommend(request: RecommendRequest):
    # Filter scanned menu names by those present in the index
    valid_scanned = [name for name in request.scanned if name in name_to_index]
    if not valid_scanned:
        raise HTTPException(status_code=400, detail="No valid scanned menu names found.")
    # Get indices of scanned menu names
    scanned_indices = [name_to_index[name] for name in valid_scanned]
    # Get embeddings for the scanned menus
    scanned_embeddings = menu_embeddings[scanned_indices]
    # Compute user embedding as mean of scanned embeddings
    user_embedding = np.mean(scanned_embeddings, axis=0, keepdims=True)
    # Compute cosine similarity between user embedding and all menu embeddings
    similarities = cosine_similarity(user_embedding, menu_embeddings)[0]

    # Filter out menus matching allergy ingredients (Korean extraction and filtering)
    allergy_set = set(request.allergies or [])
    recommendations = []
    for idx, meta in enumerate(menu_metadata):
        # 1) Extract Korean ingredients string
        ingredients_ko = meta.get('ingredients', {}).get('ko', '')
        # 2) Tokenize into individual ingredients
        ing_list = [ing.strip() for ing in ingredients_ko.split(',') if ing.strip()]
        ing_set = set(ing_list)

        # 3) Allergy filter: skip if any allergen appears in ingredients
        if allergy_set and any(allergen in ing_set for allergen in allergy_set):
            continue

        # 4) Append recommendation entry
        recommendations.append({
            "menu_name": meta.get("menu_name", {}).get("ko", str(meta.get("menu_name"))),
            "ingredients": ing_list,
            "similarity": float(similarities[idx])
        })
    # Sort by similarity descending
    recommendations.sort(key=lambda x: x["similarity"], reverse=True)
    # Remove scanned menu items from recommendations
    scanned_names = set(valid_scanned)
    recommendations = [rec for rec in recommendations if rec["menu_name"] not in scanned_names]
    # Return top_k recommendations
    return {"recommendations": recommendations[:request.top_k]}

if __name__ == '__main__':
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)