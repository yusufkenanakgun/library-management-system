namespace BorrowService.Models
{
    public class Borrow
    {
        public int Id { get; set; } // Borrow ID
        public string Username { get; set; } = default!;
        public string FullName { get; set; } = default!;
        public Guid BookId { get; set; }
        public DateTime BorrowDate { get; set; }
        public DateTime ExpectedReturnDate { get; set; }
        public DateTime? ActualReturnDate { get; set; } // Geri getirdiyse bu dolacak
    }
}
