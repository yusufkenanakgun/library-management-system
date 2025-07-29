using FavoriteService.Models;
using FavoriteService.Data;
using Microsoft.EntityFrameworkCore;
using FavoriteService.Services;

namespace FavoriteService.Services
{
    public class FavoriteManager : IFavoriteService
    {
        private readonly FavoriteDbContext _context;

        public FavoriteManager(FavoriteDbContext context)
        {
            _context = context;
        }

        public async Task<int> RemoveAllByUsernameAsync(string username)
{
    var favorites = await _context.Favorites
        .Where(f => f.Username == username)
        .ToListAsync();

    if (!favorites.Any())
        return 0;

    _context.Favorites.RemoveRange(favorites);
    await _context.SaveChangesAsync();

    return favorites.Count;
}


        public async Task<List<Favorite>> GetAllAsync()
        {
            return await _context.Favorites.ToListAsync();
        }

        public async Task<List<Favorite>> GetByUsernameAsync(string username)
        {
            return await _context.Favorites
                .Where(f => f.Username == username)
                .ToListAsync();
        }

        public async Task<List<Favorite>> GetByUserIdAsync(long userId)
        {
            return await _context.Favorites
                .Where(f => f.UserId == userId)
                .ToListAsync();
        }

        public async Task<Favorite?> FindAsync(Guid bookId, string username)
        {
            return await _context.Favorites
                .FirstOrDefaultAsync(f => f.BookId == bookId && f.Username == username);
        }

        public async Task<Favorite> AddAsync(Favorite favorite)
        {
            _context.Favorites.Add(favorite);
            await _context.SaveChangesAsync();
            return favorite;
        }

        public async Task<bool> RemoveAsync(int id)
        {
            var favorite = await _context.Favorites.FindAsync(id);
            if (favorite == null)
                return false;

            _context.Favorites.Remove(favorite);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
