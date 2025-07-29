using BorrowService.Models;
using BorrowService.Dtos;
using BorrowService.Data;
using Microsoft.EntityFrameworkCore;
using System.Net.Http;

namespace BorrowService.Services
{
    public class BorrowManager : IBorrowService
    {
        private readonly BorrowDbContext _context;
        private readonly IBookServiceClient _bookServiceClient;
        private readonly IHttpClientFactory _httpClientFactory;

        public BorrowManager(BorrowDbContext context, IBookServiceClient bookServiceClient, IHttpClientFactory httpClientFactory)
        {
            _context = context;
            _bookServiceClient = bookServiceClient;
            _httpClientFactory = httpClientFactory;
        }

        public async Task<List<Borrow>> GetAllAsync()
        {
            return await _context.Borrows.ToListAsync();
        }

        public async Task<Borrow?> GetByIdAsync(int id)
        {
            return await _context.Borrows.FindAsync(id);
        }
        public async Task<List<Borrow>> GetByUsernameAsync(string username)
{
    return await _context.Borrows
        .Where(b => b.Username == username)
        .OrderByDescending(b => b.BorrowDate)
        .ToListAsync();
}

        public async Task<Borrow> BorrowBookAsync(BorrowRequestDto request)
        {
            if (request.BorrowDurationInWeeks < 1 || request.BorrowDurationInWeeks > 2)
                throw new ArgumentException("Borrow duration must be between 1 and 2 weeks.");

            var borrowDate = DateTime.UtcNow;
            var expectedReturnDate = borrowDate.AddDays(request.BorrowDurationInWeeks * 7);

            var borrow = new Borrow
            {
                Username = request.Username,
                FullName = request.FullName,
                BookId = request.BookId,
                BorrowDate = borrowDate,
                ExpectedReturnDate = expectedReturnDate,
                ActualReturnDate = null
            };

            _context.Borrows.Add(borrow);
            await _context.SaveChangesAsync();

            await _bookServiceClient.UpdateAvailabilityAsync(request.BookId, false);

            return borrow;
        }

        public async Task SendDueNotificationsAsync()
{
    var tomorrow = DateTime.UtcNow.Date.AddDays(1);

    var dueBorrows = await _context.Borrows
        .Where(b => b.ExpectedReturnDate.Date == tomorrow && b.ActualReturnDate == null)
        .ToListAsync();

    var client = _httpClientFactory.CreateClient("notification");

    foreach (var borrow in dueBorrows)
    {
        var message = $"📚 '{borrow.BookId}' kitabını yarın iade etmeniz gerekiyor.";
        var notification = new
        {
            Username = borrow.Username,
            Message = message
        };

        await client.PostAsJsonAsync("/api/notification", notification);
    }
}


        public async Task<bool> ReturnBookAsync(int id)
        {
            var borrow = await _context.Borrows.FindAsync(id);
            if (borrow == null)
                return false;

            borrow.ActualReturnDate = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            await _bookServiceClient.UpdateAvailabilityAsync(borrow.BookId, true);

            try
            {
                var client = _httpClientFactory.CreateClient("reservation");
                var response = await client.PostAsync($"/api/reservation/assign/{borrow.BookId}", null);

                if (!response.IsSuccessStatusCode)
                {
                    Console.WriteLine($"❌ Reservation promotion çağrısı başarısız: {response.StatusCode}");
                }
                else
                {
                    Console.WriteLine($"✅ Reservation promotion başarılı: {borrow.BookId}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ ReservationService çağrısı başarısız: {ex.Message}");
            }

            return true;
        }

        public async Task<Borrow?> GetLastBorrowByBookIdAsync(Guid bookId)
        {
            return await _context.Borrows
                .Where(b => b.BookId == bookId)
                .OrderByDescending(b => b.BorrowDate)
                .FirstOrDefaultAsync();
        }
    }
}
