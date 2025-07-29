using BorrowService.Dtos;
using System.Threading.Tasks;

namespace BorrowService.Services
{
    public interface IBookServiceClient
    {
        Task<BookDto?> GetBookByIdAsync(Guid bookId);
        Task<bool> UpdateAvailabilityAsync(Guid bookId, bool isAvailable); // 📌 Bunu ekledik
    }
}
