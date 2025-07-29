using ReservationService.Models;
using ReservationService.Dtos;

namespace ReservationService.Services
{
    public interface IReservationService
    {
        List<Reservation> GetAll();
        List<Reservation> GetByUsername(string username);
        void ReserveBook(Reservation reservation);
        void CancelReservation(int id);
        Task<int> RemoveAllByUsernameAsync(string username);

        Reservation? GetNextReservationForBook(Guid bookId);
        Task AssignReservationToBorrow(Guid bookId);
        Task<int> CalculateEstimatedWaitTimeAsync(string username);
        Task<List<ReservationWithEtaDto>> GetByUsernameWithEta(string username);
        Task<bool> TryPromoteNextReservationAsync(Guid bookId);

    }
}
