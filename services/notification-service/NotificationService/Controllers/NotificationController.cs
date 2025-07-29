using Microsoft.AspNetCore.Mvc;
using NotificationService.Models;
using NotificationService.Services;

namespace NotificationService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NotificationController : ControllerBase
{
    private readonly INotificationService _service;

    public NotificationController(INotificationService service)
    {
        _service = service;
    }

    [HttpGet("{username}")]
    public async Task<ActionResult<List<Notification>>> Get(string username)
    {
        return await _service.GetByUsernameAsync(username);
    }

    [HttpPost]
    public async Task<ActionResult<Notification>> Post([FromBody] Notification notification)
    {
        var result = await _service.AddAsync(notification);
        return CreatedAtAction(nameof(Get), new { username = notification.Username }, result);
    }

    [HttpPut("{id}/read")]
    public async Task<IActionResult> MarkAsRead(int id)
    {
        await _service.MarkAsReadAsync(id);
        return NoContent();
    }
}
