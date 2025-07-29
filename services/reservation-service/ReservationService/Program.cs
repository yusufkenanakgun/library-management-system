using ReservationService.Services;
using ReservationService.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Controller'lar
builder.Services.AddControllers();

// Business Logic Service
builder.Services.AddScoped<IReservationService, ReservationManager>();

// Named HttpClients
builder.Services.AddHttpClient("borrow", client =>
{
    client.BaseAddress = new Uri("http://borrow-service:8080");
});
builder.Services.AddHttpClient("book", client =>
{
    client.BaseAddress = new Uri("http://book-service:8080");
});

// DbContext
builder.Services.AddDbContext<ReservationDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// CORS
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

// Otomatik migration
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<ReservationDbContext>();
    db.Database.Migrate();
}

// Middleware
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();
