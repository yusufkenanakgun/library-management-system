Write-Host "Creating microservices..."

mkdir services\auth-service
cd services\auth-service
dotnet new webapi -n AuthService
cd ../..

mkdir services\book-service
cd services\book-service
dotnet new webapi -n BookService
cd ../..

mkdir services\borrow-service
cd services\borrow-service
dotnet new webapi -n BorrowService
cd ../..

mkdir services\reservation-service
cd services\reservation-service
dotnet new webapi -n ReservationService
cd ../..

mkdir services\notification-service
cd services\notification-service
dotnet new webapi -n NotificationService
cd ../..

mkdir services\recommendation-service
cd services\recommendation-service
dotnet new webapi -n RecommendationService
cd ../..

Write-Host "All services created successfully!"
