namespace BorrowService.Dtos
{
    public class BorrowRequestDto
    {
        public string Username { get; set; } = default!;
        public string FullName { get; set; } = default!;
        public Guid BookId { get; set; }
        
        public int BorrowDurationInWeeks { get; set; } // 📌 Kullanıcının kaç hafta kiralayacağı
        
        public DateTime BorrowDate { get; set; } = DateTime.UtcNow; // 📌 Backend tarafından atanacak
        public DateTime ExpectedReturnDate { get; set; } // 📌 Backend hesaplayacak (BorrowDate + BorrowDurationInWeeks * 7 gün)
    }
}
