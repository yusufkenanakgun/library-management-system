using FavoriteService.Models;
using FavoriteService.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Npgsql;

namespace FavoriteService.Controllers
{
    [ApiController]
    [Route("api/favorite")]
    public class FavoriteController : ControllerBase
    {
        private readonly IFavoriteService _favoriteService;

        public FavoriteController(IFavoriteService favoriteService)
        {
            _favoriteService = favoriteService;
        }

        [HttpGet("test")]
        public ActionResult<string> Test() 
        {
            return Ok("Favorite service is working!");
        }

        [HttpGet]
        public async Task<ActionResult<List<Favorite>>> GetAll()
        {
            return await _favoriteService.GetAllAsync();
        }

        [HttpGet("user/{username}")]
        public async Task<ActionResult<List<Favorite>>> GetByUsername(string username)
        {
            return await _favoriteService.GetByUsernameAsync(username);
        }

        [HttpGet("by-user/{userId}")]
        public async Task<ActionResult<List<Favorite>>> GetByUserId(long userId)
        {
            var favorites = await _favoriteService.GetByUserIdAsync(userId);
            if (favorites == null || !favorites.Any())
                return NotFound("Bu kullanıcıya ait favori kitap bulunamadı.");
            return Ok(favorites);
        }

        [HttpDelete("user/{username}")]
public async Task<IActionResult> DeleteByUsername(string username)
{
    var deletedCount = await _favoriteService.RemoveAllByUsernameAsync(username);

    if (deletedCount == 0)
        return NotFound("Bu kullanıcıya ait favori kitap yok.");

    return NoContent();
}



        [HttpPost]
        public async Task<IActionResult> Add([FromBody] Favorite favorite)
        {
            // Flutter veya frontend zaten kontrol etse de, backend güvenliği garantiler
           var existing = await _favoriteService.FindAsync(favorite.BookId, favorite.Username);
           if (existing != null)
                return Conflict("Bu kitap zaten favorilere eklenmiş.");

            try
           {
                var addedFavorite = await _favoriteService.AddAsync(favorite);
                return CreatedAtAction(nameof(GetByUsername), new { username = favorite.Username }, addedFavorite);
            }
            catch (DbUpdateException ex) when (ex.InnerException is PostgresException pgex && pgex.SqlState == "23505")
            {
                return Conflict("Bu kitap zaten favorilere eklenmiş (veritabanı kontrolü).");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Beklenmeyen bir hata oluştu: {ex.Message}");
            }
        }



        [HttpDelete("{id}")]
        public async Task<IActionResult> Remove(int id)
        {
            var success = await _favoriteService.RemoveAsync(id);
            if (!success)
                return NotFound();

            return NoContent();
        }
    }
}
