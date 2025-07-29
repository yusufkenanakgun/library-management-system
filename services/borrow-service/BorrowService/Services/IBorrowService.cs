using BorrowService.Models;
using BorrowService.Dtos;

namespace BorrowService.Services
{
    public interface IBorrowService
    {
        Task<List<Borrow>> GetAllAsync();
        Task<Borrow?> GetByIdAsync(int id);
        Task<Borrow> BorrowBookAsync(BorrowRequestDto request);
        Task<bool> ReturnBookAsync(int id);
        Task SendDueNotificationsAsync();

        Task<List<Borrow>> GetByUsernameAsync(string username);

        // 📌 Yeni method: BookId'ye göre son Borrow kaydını getir
        Task<Borrow?> GetLastBorrowByBookIdAsync(Guid bookId);
    }
}
