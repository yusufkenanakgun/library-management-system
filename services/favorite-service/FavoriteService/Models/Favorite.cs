namespace FavoriteService.Models
{
    public class Favorite
    {
        public int Id { get; set; }
        public string Username { get; set; } = default!; // 📌 Username (ör: testuser@example.com)
        public string FullName { get; set; } = default!; // 📌 FullName (ör: Test User)
        public Guid BookId { get; set; } // 📌 BookId artık Guid
        public long UserId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
