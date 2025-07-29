using ReservationService.Data;
using ReservationService.Models;
using Microsoft.EntityFrameworkCore;
using System.Net.Http.Json;
using ReservationService.Dtos;

namespace ReservationService.Services
{
    public class ReservationManager : IReservationService
    {
        private readonly ReservationDbContext _context;
        private readonly IHttpClientFactory _httpClientFactory;

        public ReservationManager(ReservationDbContext context, IHttpClientFactory httpClientFactory)
        {
            _context = context;
            _httpClientFactory = httpClientFactory;
        }

        public List<Reservation> GetAll() => _context.Reservations.ToList();

        public List<Reservation> GetByUsername(string username) =>
            _context.Reservations.Where(r => r.Username == username).ToList();

        public void ReserveBook(Reservation reservation)
        {
            if (_context.Reservations.Any(r => r.Username == reservation.Username && r.BookId == reservation.BookId))
                throw new InvalidOperationException("Bu kullanıcı bu kitabı zaten rezerve etti.");

            if (reservation.BorrowDurationInWeeks is < 1 or > 2)
                throw new ArgumentException("Borrow süresi 1 ile 2 hafta arasında olmalıdır.");

            reservation.ReservationDate = DateTime.UtcNow;
            reservation.ExpirationDate = DateTime.UtcNow.AddDays(7);

            _context.Reservations.Add(reservation);
            _context.SaveChanges();
        }

        public void CancelReservation(int id)
        {
            var reservation = _context.Reservations.Find(id);
            if (reservation != null)
            {
                _context.Reservations.Remove(reservation);
                _context.SaveChanges();
            }
        }

        public async Task<int> RemoveAllByUsernameAsync(string username)
{
    var reservations = await _context.Reservations
        .Where(r => r.Username == username)
        .ToListAsync();

    if (!reservations.Any())
        return 0;

    _context.Reservations.RemoveRange(reservations);
    await _context.SaveChangesAsync();

    return reservations.Count;
}


        public Reservation? GetNextReservationForBook(Guid bookId)
        {
            var now = DateTime.UtcNow;

            var expiredReservations = _context.Reservations
                .Where(r => r.BookId == bookId && r.ExpirationDate < now)
                .ToList();

            if (expiredReservations.Any())
            {
                _context.Reservations.RemoveRange(expiredReservations);
                _context.SaveChanges();
            }

            return _context.Reservations
                .Where(r => r.BookId == bookId)
                .OrderBy(r => r.ReservationDate)
                .FirstOrDefault();
        }

        public async Task AssignReservationToBorrow(Guid bookId)
        {
            var reservation = GetNextReservationForBook(bookId);
            if (reservation == null)
            {
                var client = _httpClientFactory.CreateClient("book");
                await client.PatchAsync($"/api/book/{bookId}/available", null);
                return;
            }

            var clientBorrow = _httpClientFactory.CreateClient("borrow");
            var borrowRequest = new
            {
                Username = reservation.Username,
                FullName = reservation.FullName,
                BookId = reservation.BookId,
                BorrowDurationInWeeks = reservation.BorrowDurationInWeeks,
                BorrowDate = DateTime.UtcNow,
                ExpectedReturnDate = DateTime.UtcNow.AddDays(reservation.BorrowDurationInWeeks * 7)
            };

            var response = await clientBorrow.PostAsJsonAsync("/api/borrow", borrowRequest);

            if (response.IsSuccessStatusCode)
            {
                _context.Reservations.Remove(reservation);
                await _context.SaveChangesAsync();
            }
            else
            {
                Console.WriteLine($"❌ BorrowService isteği başarısız. StatusCode: {response.StatusCode}");
            }
        }

        public async Task<int> CalculateEstimatedWaitTimeAsync(string username)
{
    var userReservation = await _context.Reservations
        .FirstOrDefaultAsync(r => r.Username == username);

    if (userReservation == null)
        return 0;

    var allReservations = await _context.Reservations
        .Where(r => r.BookId == userReservation.BookId)
        .OrderBy(r => r.ReservationDate)
        .ToListAsync();

    int etaDays = 0;
    foreach (var reservation in allReservations)
    {
        if (reservation.Id == userReservation.Id)
            break;
        etaDays += reservation.BorrowDurationInWeeks * 7;
    }

    try
    {
        var client = _httpClientFactory.CreateClient("borrow");
        var borrow = await client.GetFromJsonAsync<BorrowDto>($"/api/borrow/book/{userReservation.BookId}");
        
        if (borrow?.ActualReturnDate.HasValue == true)
        {
            var delay = (borrow.ActualReturnDate.Value - borrow.ExpectedReturnDate).Days;
            if (delay > 0) etaDays += delay;
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"ETA hesaplaması sırasında hata: {ex.Message}");
    }

    return etaDays;
}


        public async Task<List<ReservationWithEtaDto>> GetByUsernameWithEta(string username)
    {
    var reservations = await _context.Reservations
        .Where(r => r.Username == username)
        .OrderBy(r => r.ReservationDate)
        .ToListAsync();

    var results = new List<ReservationWithEtaDto>();

    foreach (var reservation in reservations)
    {
        var eta = await CalculateEstimatedWaitTimeAsync(reservation.Username);
        results.Add(new ReservationWithEtaDto
        {
            Id = reservation.Id,
            Username = reservation.Username,
            BookId = reservation.BookId,
            ReservationDate = reservation.ReservationDate,
            BorrowDurationInWeeks = reservation.BorrowDurationInWeeks,
            EstimatedWaitDays = eta
        });
    }

        return results;
    }


        public async Task<bool> TryPromoteNextReservationAsync(Guid bookId)
        {
            var nextReservation = await _context.Reservations
                .Where(r => r.BookId == bookId)
                .OrderBy(r => r.ReservationDate)
                .FirstOrDefaultAsync();

            if (nextReservation == null) return false;

            var client = _httpClientFactory.CreateClient("borrow");
            var borrowRequest = new
            {
                Username = nextReservation.Username,
                FullName = nextReservation.FullName,
                BookId = nextReservation.BookId,
                BorrowDurationInWeeks = nextReservation.BorrowDurationInWeeks,
                BorrowDate = DateTime.UtcNow,
                ExpectedReturnDate = DateTime.UtcNow.AddDays(nextReservation.BorrowDurationInWeeks * 7)
            };

            var response = await client.PostAsJsonAsync("/api/borrow", borrowRequest);

            if (!response.IsSuccessStatusCode)
            {
                Console.WriteLine($"❌ Promote işlemi başarısız oldu: {response.StatusCode}");
                return false;
            }

            _context.Reservations.Remove(nextReservation);
            await _context.SaveChangesAsync();
            return true;
        }

        private class BorrowDto
        {
            public DateTime BorrowDate { get; set; }
            public DateTime ExpectedReturnDate { get; set; }
            public DateTime? ActualReturnDate { get; set; }
        }
    }
}
