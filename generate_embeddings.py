from sentence_transformers import SentenceTransformer
import json

INPUT_FILE = "books_with_ids.json"
OUTPUT_FILE = "books_with_embeddings.json"

# 🔍 Modeli yükle
model = SentenceTransformer("all-MiniLM-L6-v2")

# 📖 Kitapları oku
with open(INPUT_FILE, "r", encoding="utf-8") as f:
    books = json.load(f)

# 🧠 Embedding üret
for book in books:
    book["embedding"] = model.encode(book["description"]).tolist()

# 💾 Yeni dosyaya kaydet
with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(books, f, ensure_ascii=False, indent=2)

print(f"✅ Embedding'ler üretildi ve '{OUTPUT_FILE}' dosyasına kaydedildi.")