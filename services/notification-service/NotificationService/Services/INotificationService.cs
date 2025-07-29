using NotificationService.Models;

namespace NotificationService.Services;

public interface INotificationService
{
    Task<List<Notification>> GetByUsernameAsync(string username);
    Task<Notification> AddAsync(Notification notification);
    Task MarkAsReadAsync(int id);
}
