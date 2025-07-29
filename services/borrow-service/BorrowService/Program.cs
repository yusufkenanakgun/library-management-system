using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using BorrowService.Services;
using BorrowService.Data;

var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddControllers();

// Scoped services
builder.Services.AddScoped<IBorrowService, BorrowManager>();
builder.Services.AddScoped<IBookServiceClient, BookServiceClient>();

// DbContext
builder.Services.AddDbContext<BorrowDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// ✅ HttpClient for BookService (injected into BookServiceClient)
builder.Services.AddHttpClient<IBookServiceClient, BookServiceClient>(client =>
{
    client.BaseAddress = new Uri("http://book-service:8080");
});

// ✅ Named HttpClient for ReservationService (used via IHttpClientFactory in BorrowManager)
builder.Services.AddHttpClient("reservation", client =>
{
    client.BaseAddress = new Uri("http://reservation-service:8080");
});

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ✅ CORS
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

// ✅ Auto database migration
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<BorrowDbContext>();
    dbContext.Database.Migrate();
}

// Middleware
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// ✅ Middleware order
app.UseCors("AllowAll");
app.UseAuthorization();
app.MapControllers();

app.Run();
