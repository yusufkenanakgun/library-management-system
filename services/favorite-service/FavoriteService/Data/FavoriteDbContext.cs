using Microsoft.EntityFrameworkCore;
using FavoriteService.Models;

namespace FavoriteService.Data
{
    public class FavoriteDbContext : DbContext
    {
        public FavoriteDbContext(DbContextOptions<FavoriteDbContext> options) : base(options)
        {
        }

        public DbSet<Favorite> Favorites { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Favorite>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Username).IsRequired();
                entity.Property(e => e.BookId).IsRequired();
                entity.Property(e => e.CreatedAt).IsRequired();

                // ✅ Duplicate favoriyi engelle (BookId + Username benzersiz olacak)
                entity.HasIndex(e => new { e.BookId, e.Username }).IsUnique();
            });
        }
    }
}
