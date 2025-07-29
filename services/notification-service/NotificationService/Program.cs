using Microsoft.EntityFrameworkCore;
using NotificationService.Data;
using NotificationService.Services;

var builder = WebApplication.CreateBuilder(args);

// 🔌 PostgreSQL bağlantısı (hata detayları dahil)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") + ";Include Error Detail=true";

// 📦 Servis kayıtları
builder.Services.AddControllers();
builder.Services.AddScoped<INotificationService, NotificationManager>();

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString));

// 🌐 Swagger (sadece dev)
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// 🌍 CORS - tüm domainlere izin
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();

// 🚀 Otomatik migration (opsiyonel ama önerilir)
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();
}

// 🧭 Middleware pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.UseAuthorization();
app.MapControllers();
app.Run();
