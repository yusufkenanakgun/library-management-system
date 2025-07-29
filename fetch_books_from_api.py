# fetch_books_from_api.py
import requests
import json

BOOKS_API = "http://localhost:8081/api/books"
OUTPUT_FILE = "books_with_ids.json"

try:
    res = requests.get(BOOKS_API)
    res.raise_for_status()
    books = res.json()

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(books, f, ensure_ascii=False, indent=2)

    print(f"✅ {len(books)} kitap 'books_with_ids.json' dosyasına kaydedildi.")

except Exception as e:
    print("❌ Hata:", e)