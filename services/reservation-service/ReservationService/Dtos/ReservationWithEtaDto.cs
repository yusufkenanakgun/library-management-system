namespace ReservationService.Dtos
{
    public class ReservationWithEtaDto
    {
        public int Id { get; set; }
        public string Username { get; set; } = default!;
        public Guid BookId { get; set; }
        public DateTime ReservationDate { get; set; }
        public int BorrowDurationInWeeks { get; set; }
        public int EstimatedWaitDays { get; set; }
    }
}
