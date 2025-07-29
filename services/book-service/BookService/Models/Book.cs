namespace BookService.Models;

public class Book
{
    public Guid Id { get; set; }
    public string Title { get; set; } = default!;
    public string Author { get; set; } = default!;
    public string Description { get; set; } = default!;
    public bool IsAvailable { get; set; } = true;
    public string Image { get; set; } = default!; // ✅ YENİ ALAN EKLEDİK
}
