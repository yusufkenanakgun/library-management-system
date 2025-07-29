from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from services.recommender import generate_recommendations

app = FastAPI()

# CORS ayarları
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Öneri servisi endpoint'i
@app.get("/recommendations/{user_id}")
def recommend(user_id: int):
    print(f"🔍 Öneri servisi çağrıldı: user_id = {user_id}")
    return generate_recommendations(user_id)

# Sağlık kontrolü için test endpoint
@app.get("/ping")
def ping():
    return {"message": "pong"}
