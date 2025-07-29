from flask import Flask, jsonify
import json
import pickle
import numpy as np
import requests
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)

# --------------------
# Load embeddings
# --------------------
with open("books_with_embeddings.json", "r", encoding="utf-8") as f:
    books_data = json.load(f)

with open("book_embeddings.pkl", "rb") as f:
    book_embeddings = pickle.load(f)

book_id_to_embedding = {
    book["bookId"]: book_embeddings[i]
    for i, book in enumerate(books_data)
}

book_id_to_info = {
    book["bookId"]: {
        "title": book["title"],
        "author": book["author"],
        "image": book["image"]
    }
    for book in books_data
}

# --------------------
# Recommendation Logic
# --------------------
def get_recommendations(user_id):
    FAVORITES_API_URL = f"http://localhost:8083/api/favorite/by-user/{user_id}"
    try:
        response = requests.get(FAVORITES_API_URL)
        response.raise_for_status()
        favorites = response.json()
    except Exception as e:
        return []

    favorite_embeddings = []
    for fav in favorites:
        book_id = fav["bookId"]
        embedding = book_id_to_embedding.get(book_id)
        if embedding is not None:
            favorite_embeddings.append(embedding)

    if not favorite_embeddings:
        return []

    avg_embedding = np.mean(favorite_embeddings, axis=0)
    similarities = cosine_similarity([avg_embedding], book_embeddings)[0]
    top_indices = similarities.argsort()[::-1]

    recommended = []
    for idx in top_indices:
        book = books_data[idx]
        if book["bookId"] not in [f["bookId"] for f in favorites]:
            recommended.append(book_id_to_info[book["bookId"]])
        if len(recommended) == 5:
            break

    return recommended

# --------------------
# Flask API Endpoint
# --------------------
@app.route("/api/recommendations/<int:user_id>", methods=["GET"])
def recommend(user_id):
    recommendations = get_recommendations(user_id)
    return jsonify(recommendations)

# --------------------
# Run Flask Server
# --------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)