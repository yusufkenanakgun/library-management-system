import json
import requests

# Kitapları yüklemek istediğin API adresi
API_URL = "http://localhost:8081/api/books"

# JWT token gerekiyorsa buraya ekle
JWT_TOKEN = None  # Örn: "eyJhbGciOiJIUzI1NiIsInR5cCI6..."

headers = {
    "Content-Type": "application/json",
}

if JWT_TOKEN:
    headers["Authorization"] = f"Bearer {JWT_TOKEN}"

# JSON dosyasını oku
with open("books_bulk_descriptions.json", "r", encoding="utf-8") as file:
    books = json.load(file)

success = 0
fail = 0

for book in books:
    payload = {
        "title": book["title"],
        "author": book["author"],
        "description": book["description"],
        "isAvailable": book.get("isAvailable", True),
        "image": book["image"],
    }

    try:
        response = requests.post(API_URL, headers=headers, json=payload)
        if response.status_code in (200, 201):
            print(f"[✅] '{book['title']}' başarıyla eklendi.")
            success += 1
        else:
            print(f"[❌] '{book['title']}' eklenemedi: {response.status_code} - {response.text}")
            fail += 1
    except Exception as e:
        print(f"[⚠️] '{book['title']}' için hata: {e}")
        fail += 1

print(f"\n📊 Toplam: {len(books)} kitap | Başarılı: {success} | Hatalı: {fail}")