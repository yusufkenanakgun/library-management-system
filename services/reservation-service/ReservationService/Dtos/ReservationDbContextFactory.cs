using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using ReservationService.Data;

namespace ReservationService
{
    public class ReservationDbContextFactory : IDesignTimeDbContextFactory<ReservationDbContext>
    {
        public ReservationDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ReservationDbContext>();
            optionsBuilder.UseNpgsql("Host=localhost;Port=5436;Database=yuread_reservation_db;Username=postgres;Password=123456");

            return new ReservationDbContext(optionsBuilder.Options);
        }
    }
}
