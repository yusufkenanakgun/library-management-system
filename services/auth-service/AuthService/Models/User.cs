namespace AuthService.Models;

public class User
{
    public int Id { get; set; }

    public string Username { get; set; } = default!; // E-posta ya da okul numarası
    public string Password { get; set; } = default!;
    public string Role { get; set; } = default!; // "user" veya "admin"
    public string FullName { get; set; } = default!;
    public string PhoneNumber { get; set; } = default!;
}
