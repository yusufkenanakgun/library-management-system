using FavoriteService.Services;
using FavoriteService.Data;
using Microsoft.EntityFrameworkCore;
using Npgsql;

var builder = WebApplication.CreateBuilder(args);

// ✅ Bağlantı cümlesi içine "Include Error Detail=true" eklendi
var connectionString = builder.Configuration
    .GetConnectionString("DefaultConnection") + ";Include Error Detail=true";

// Add services
builder.Services.AddControllers();
builder.Services.AddScoped<IFavoriteService, FavoriteManager>();

builder.Services.AddDbContext<FavoriteDbContext>(options =>
    options.UseNpgsql(connectionString));

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ✅ CORS ayarı
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

// ✅ Auto migration (opsiyonel ama faydalı)
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<FavoriteDbContext>();
    dbContext.Database.Migrate();
}

// Middleware
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// ✅ CORS middleware
app.UseCors("AllowAll");

app.UseAuthorization();
app.MapControllers();
app.Run();
