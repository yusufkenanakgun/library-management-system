using Microsoft.EntityFrameworkCore;
using NotificationService.Data;
using NotificationService.Models;

namespace NotificationService.Services;

public class NotificationManager : INotificationService
{
    private readonly AppDbContext _context;

    public NotificationManager(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<Notification>> GetByUsernameAsync(string username)
    {
        return await _context.Notifications
            .Where(n => n.Username == username)
            .OrderByDescending(n => n.CreatedAt)
            .ToListAsync();
    }

    public async Task<Notification> AddAsync(Notification notification)
    {
        _context.Notifications.Add(notification);
        await _context.SaveChangesAsync();
        return notification;
    }

    public async Task MarkAsReadAsync(int id)
    {
        var notification = await _context.Notifications.FindAsync(id);
        if (notification != null)
        {
            notification.IsRead = true;
            await _context.SaveChangesAsync();
        }
    }
}
