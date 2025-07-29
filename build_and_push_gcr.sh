#!/bin/bash

# --- Yapılandırma ---
YOUR_PROJECT_ID="capable-era-461401-t1"      # Google Cloud Proje Kimliğiniz
YOUR_REGION="europe-west1"                   # Artifact Registry havuzunuzu oluşturduğunuz bölge
YOUR_REPOSITORY_NAME="kutuphane-servisleri"  # Artifact Registry'de oluşturduğunuz havuz adı

# --- Servis Tanımları (docker-compose.yml dosyanıza göre) ---
# Her giriş: "servis_adı:Dockerfile_konteks_yolu"
declare -A services
services=(
    "auth-service:./services/auth-service/AuthService"
    "book-service:./services/book-service/BookService"
    "borrow-service:./services/borrow-service/BorrowService"
    "favorite-service:./services/favorite-service/FavoriteService"
    "reservation-service:./services/reservation-service/ReservationService"
    "recommendation-service:./services/recommendation-service/RecommendationService"
    "notification-service:./services/notification-service/NotificationService"
)

# --- Ana Script ---
echo "Tüm servisler için Docker imajı derleme ve Artifact Registry'ye gönderme işlemi başlatılıyor..."
echo "Proje Kimliği: $YOUR_PROJECT_ID"
echo "Bölge: $YOUR_REGION"
echo "Havuz Adı: $YOUR_REPOSITORY_NAME"
echo "---"

for service_name_and_path in "${!services[@]}"; do
    service_name=$(echo "$service_name_and_path" | cut -d':' -f1)
    context_path=$(echo "$service_name_and_path" | cut -d':' -f2)

    # Artifact Registry için imaj adı formatı
    IMAGE_NAME="${YOUR_REGION}-docker.pkg.dev/${YOUR_PROJECT_ID}/${YOUR_REPOSITORY_NAME}/${service_name}:latest"

    echo "Servis işleniyor: ${service_name}"
    echo "  Konteks yolu: ${context_path}"
    echo "  İmaj adı: ${IMAGE_NAME}"

    echo "${service_name} için Docker imajı derleniyor..."
    docker build -t "${IMAGE_NAME}" "${context_path}"

    if [ $? -eq 0 ]; then
        echo "${service_name} imajı başarıyla derlendi."
        echo "${service_name} Docker imajı Artifact Registry'ye gönderiliyor..."
        docker push "${IMAGE_NAME}"

        if [ $? -eq 0 ]; then
            echo "${service_name} Artifact Registry'ye başarıyla gönderildi."
        else
            echo "HATA: ${service_name} imajı gönderilemedi. Lütfen yukarıdaki hatayı kontrol edin."
        fi
    else
        echo "HATA: ${service_name} imajı derlenemedi. Lütfen Dockerfile'ınızı ve konteks yolunu kontrol edin."
    fi
    echo "---"
done

echo "Tüm servisler işlendi."