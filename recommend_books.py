
import json
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

# JSON dosyasını yükle
with open("books_with_embeddings.json", "r", encoding="utf-8") as f:
    books = json.load(f)

# Başlıklara göre indeks oluştur
title_to_index = {book["title"]: idx for idx, book in enumerate(books)}
embeddings = np.array([book["embedding"] for book in books])

def recommend_books(title, top_n=5):
    if title not in title_to_index:
        print(f"'{title}' adlı kitap bulunamadı.")
        return

    index = title_to_index[title]
    target_vec = embeddings[index].reshape(1, -1)

    similarities = cosine_similarity(target_vec, embeddings)[0]
    similar_indices = similarities.argsort()[::-1][1:top_n+1]

    print(f"📚 '{title}' için önerilen kitaplar:")
    for i, idx in enumerate(similar_indices, 1):
        print(f"{i}. {books[idx]['title']}")

# Kullanıcıdan başlık al
if __name__ == "__main__":
    book_title = input("Kitap başlığını girin: ")
    recommend_books(book_title)
