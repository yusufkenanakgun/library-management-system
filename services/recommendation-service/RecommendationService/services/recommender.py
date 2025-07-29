import requests
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')

BOOKS_API_URL = "http://book-service:8080/api/books"
FAVORITES_API_TEMPLATE = "http://favorite-service:8080/api/favorite/by-user/{user_id}"

def fetch_books():
    try:
        response = requests.get(BOOKS_API_URL)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print("📚 Kitaplar alınamadı:", e)
        return []

def generate_recommendations(user_id: int):
    print(f"🚀 Kullanıcı {user_id} için öneri işlemi başladı")

    books = fetch_books()
    if not books:
        print("❌ Kitap listesi boş")
        return {"error": "Kitap listesi alınamadı"}

    descriptions = [book.get("description", "") for book in books]
    book_embeddings = model.encode(descriptions, convert_to_numpy=True)
    book_id_to_index = {book["id"]: idx for idx, book in enumerate(books)}

    try:
        response = requests.get(FAVORITES_API_TEMPLATE.format(user_id=user_id))
        response.raise_for_status()
        favorites = response.json()
        print(f"🎯 Favoriler başarıyla çekildi: {favorites}")
    except Exception as e:
        print(f"❌ Favoriler alınamadı: {e}")
        return {"error": f"❌ Favoriler alınamadı: {str(e)}"}

    favorite_ids = [fav["bookId"] for fav in favorites]
    print(f"👍 Favorite ID'ler: {favorite_ids}")

    favorite_vectors = []
    for bid in favorite_ids:
        if bid in book_id_to_index:
            favorite_vectors.append(book_embeddings[book_id_to_index[bid]])
        else:
            print(f"⚠️ Uyuşmayan ID: {bid}")

    if not favorite_vectors:
        print("📭 Hiçbir geçerli favori vektörü bulunamadı")
        return []

    avg_vector = np.mean(favorite_vectors, axis=0)
    similarities = cosine_similarity([avg_vector], book_embeddings)[0]

    top_indices = np.argsort(similarities)[::-1]
    recommended = []

    for idx in top_indices:
        book = books[idx]
        if book["id"] not in favorite_ids:
            recommended.append(book)
        if len(recommended) >= 5:
            break

    print("✅ Öneriler başarıyla oluşturuldu")
    return recommended
