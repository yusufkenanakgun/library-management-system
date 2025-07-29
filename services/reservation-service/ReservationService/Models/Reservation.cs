namespace ReservationService.Models;

public class Reservation
{
    public int Id { get; set; }
    public string Username { get; set; } = default!; 
    public string FullName { get; set; } = default!;
    public Guid BookId { get; set; }
    public DateTime ReservationDate { get; set; }
    public DateTime ExpirationDate { get; set; }
    public int BorrowDurationInWeeks { get; set; }
}
