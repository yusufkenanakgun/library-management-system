using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AuthService.Models;
using AuthService.Services;
using AuthService.DTOs;
using AuthService.Data;

namespace AuthService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IJwtService _jwtService;
    private readonly AppDbContext _context;

    public AuthController(IJwtService jwtService, AppDbContext context)
    {
        _jwtService = jwtService;
        _context = context;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] UserRegisterDto dto)
    {
        if (await _context.Users.AnyAsync(u => u.Username == dto.Username))
            return BadRequest("Username already exists.");

        var user = new User
        {
            Username = dto.Username,
            Password = BCrypt.Net.BCrypt.HashPassword(dto.Password),
            Role = dto.Role,
            FullName = dto.FullName,
            PhoneNumber = dto.PhoneNumber
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return Ok("User registered successfully.");
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] UserLogin dto)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == dto.Username);
        if (user == null || !BCrypt.Net.BCrypt.Verify(dto.Password, user.Password))
            return Unauthorized("Invalid credentials.");

        var token = _jwtService.GenerateToken(user);
        return Ok(new { token });
    }

    [HttpDelete("{username}")]
public async Task<IActionResult> DeleteUser(string username)
{
    var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
    if (user == null)
        return NotFound("User not found.");

    _context.Users.Remove(user);
    await _context.SaveChangesAsync();

    return Ok("User deleted successfully.");
}


    [HttpGet]
    public async Task<ActionResult<List<User>>> GetAllUsers()
    {
        var users = await _context.Users.ToListAsync();
        return Ok(users);
    }

}
