using Microsoft.EntityFrameworkCore;
using ReservationService.Models;

namespace ReservationService.Data
{
    public class ReservationDbContext : DbContext
    {
        public ReservationDbContext(DbContextOptions<ReservationDbContext> options) : base(options) { }

        public DbSet<Reservation> Reservations { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Reservation>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Username).IsRequired();
                entity.Property(e => e.BookId).IsRequired();
                entity.Property(e => e.ReservationDate).IsRequired();
                entity.Property(e => e.ExpirationDate).IsRequired();
            });
        }
    }
}
