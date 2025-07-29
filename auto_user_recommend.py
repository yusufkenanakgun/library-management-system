import requests
import json
import numpy as np
import pickle
from sklearn.metrics.pairwise import cosine_similarity

# Dosya yolları
EMBEDDINGS_FILE = "book_embeddings.pkl"
BOOKS_FILE = "books_with_embeddings.json"
FAVORITES_API_URL = "http://localhost:8083/api/favorite/by-user/1"

# 1. Embedding'leri yükle
with open(EMBEDDINGS_FILE, "rb") as f:
    embeddings = pickle.load(f)

# 2. Kitapları yükle
with open(BOOKS_FILE, "r", encoding="utf-8") as f:
    books = json.load(f)

# 3. Book ID → Index haritası
id_to_index = {book["id"]: idx for idx, book in enumerate(books) if "id" in book}

# 4. Kullanıcının favori kitap ID'lerini al
try:
    response = requests.get(FAVORITES_API_URL)
    response.raise_for_status()
    favorite_book_ids = [fav["bookId"] for fav in response.json()]
except Exception as e:
    print("\n❌ Kullanıcının favorileri alınamadı:", e)
    exit()

# 5. Embedding'lerini al
valid_favorites = [id_to_index[bid] for bid in favorite_book_ids if bid in id_to_index]

if not valid_favorites:
    print("\n⚠️ Geçerli favori kitap bulunamadı.")
    exit()

favorite_embeddings = [embeddings[i] for i in valid_favorites]
user_vector = np.mean(favorite_embeddings, axis=0).reshape(1, -1)

# 6. Benzerlikleri hesapla
similarities = cosine_similarity(user_vector, embeddings)[0]
sim_indices = similarities.argsort()[::-1]

# 7. Kullanıcının favorileri haricinde ilk 5 öneri
recommended = []
for idx in sim_indices:
    book_id = books[idx]["id"]
    if book_id not in favorite_book_ids:
        recommended.append(books[idx]["title"])
    if len(recommended) == 5:
        break

# 8. Göster
print("\n\U0001F4DA Kullanıcının favorilerine göre öneriler:")
for i, title in enumerate(recommended, 1):
    print(f"{i}. {title}")