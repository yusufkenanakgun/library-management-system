
import json
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

# Embedding'li kitapları yükle
with open("books_with_embeddings.json", "r", encoding="utf-8") as f:
    books = json.load(f)

# Başlığa göre indeks
title_to_index = {book["title"]: idx for idx, book in enumerate(books)}
embeddings = np.array([book["embedding"] for book in books])

def recommend_from_favorites(favorite_titles, top_n=5):
    indices = []
    for title in favorite_titles:
        if title in title_to_index:
            indices.append(title_to_index[title])
        else:
            print(f"⚠️ '{title}' bulunamadı, atlanıyor.")

    if not indices:
        print("⚠️ Geçerli favori kitap bulunamadı.")
        return

    # Favori kitapların ortalama embedding'i
    user_vector = np.mean([embeddings[i] for i in indices], axis=0).reshape(1, -1)

    # Tüm kitaplarla cosine similarity hesapla
    similarities = cosine_similarity(user_vector, embeddings)[0]

    # Favori kitaplar hariç en yakın önerileri seç
    for idx in indices:
        similarities[idx] = -1

    top_indices = similarities.argsort()[::-1][:top_n]
    print("\n📚 Favori kitaplarınıza göre öneriler:")
    for i, idx in enumerate(top_indices, 1):
        print(f"{i}. {books[idx]['title']}")

if __name__ == "__main__":
    print("Favori kitap başlıklarını virgülle ayırarak girin:")
    user_input = input("> ")
    favorite_titles = [t.strip() for t in user_input.split(",")]
    recommend_from_favorites(favorite_titles)
