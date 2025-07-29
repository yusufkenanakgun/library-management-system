using Microsoft.EntityFrameworkCore;
using BorrowService.Models;

namespace BorrowService.Data
{
    public class BorrowDbContext : DbContext
    {
        public BorrowDbContext(DbContextOptions<BorrowDbContext> options) : base(options)
        {
        }

        public DbSet<Borrow> Borrows { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Borrow>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Username).IsRequired();
                entity.Property(e => e.FullName).IsRequired();
                entity.Property(e => e.BookId).IsRequired();
                entity.Property(e => e.BorrowDate).IsRequired();
                entity.Property(e => e.ExpectedReturnDate).IsRequired();
                entity.Property(e => e.ActualReturnDate);
            });
        }
    }
}
