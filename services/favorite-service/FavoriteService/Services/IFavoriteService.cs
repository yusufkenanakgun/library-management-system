using FavoriteService.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FavoriteService.Services
{
    public interface IFavoriteService
    {
        Task<List<Favorite>> GetAllAsync();
        Task<List<Favorite>> GetByUsernameAsync(string username);
        Task<List<Favorite>> GetByUserIdAsync(long userId);
        Task<Favorite?> FindAsync(Guid bookId, string username); // 🔍 Duplicate kontrolü
        Task<Favorite> AddAsync(Favorite favorite);
        Task<bool> RemoveAsync(int id);
        Task<int> RemoveAllByUsernameAsync(string username);

    }
}
