FROM python:3.10-slim

WORKDIR /app

# Gereken sadece requirements dosyasını kopyala önce
COPY requirements.txt .

# Sadece bu adımda bağımlılıkları yükle (cache için önemli)
RUN pip install --no-cache-dir -r requirements.txt

# Sonra kalan her şeyi kopyala
COPY . .

EXPOSE 8085

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8085"]
