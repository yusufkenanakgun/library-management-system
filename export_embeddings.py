import json
import pickle
import numpy as np

# Dosya adları
INPUT_FILE = "books_with_embeddings.json"
OUTPUT_FILE = "book_embeddings.pkl"

# Kitapları yükle
with open(INPUT_FILE, "r", encoding="utf-8") as f:
    books = json.load(f)

# Embedding'leri çıkar
embeddings = [book["embedding"] for book in books]

# NumPy array olarak kaydet
with open(OUTPUT_FILE, "wb") as f:
    pickle.dump(np.array(embeddings), f)

print(f"✅ Embedding'ler başarıyla '{OUTPUT_FILE}' dosyasına aktarıldı.")