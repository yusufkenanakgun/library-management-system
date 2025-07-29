// ReservationController.cs
using Microsoft.AspNetCore.Mvc;
using ReservationService.Models;
using ReservationService.Services;
using ReservationService.Dtos;

namespace ReservationService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReservationController : ControllerBase
    {
        private readonly IReservationService _reservationService;

        public ReservationController(IReservationService reservationService)
        {
            _reservationService = reservationService;
        }

        [HttpGet]
        public ActionResult<List<Reservation>> GetAll() => _reservationService.GetAll();

        [HttpGet("user/{username}")]
        public ActionResult<List<Reservation>> GetByUsername(string username) => _reservationService.GetByUsername(username);

        [HttpGet("user/{username}/eta")]
        public async Task<IActionResult> GetEstimatedWaitTimeAsync(string username)
        {
            var etaInDays = await _reservationService.CalculateEstimatedWaitTimeAsync(username);
            return Ok(etaInDays);
        }


        [HttpGet("user/{username}/with-eta")]
        public async Task<ActionResult<List<ReservationWithEtaDto>>> GetByUsernameWithEta(string username)
        {
            var reservationsWithEta = await _reservationService.GetByUsernameWithEta(username);
            return Ok(reservationsWithEta);
        }

        [HttpDelete("user/{username}")]
public async Task<IActionResult> DeleteByUsername(string username)
{
    var deletedCount = await _reservationService.RemoveAllByUsernameAsync(username);

    if (deletedCount == 0)
        return NotFound("Bu kullanıcıya ait rezervasyon bulunamadı.");

    return NoContent();
}



        [HttpPost]
        public IActionResult ReserveBook([FromBody] Reservation reservation)
        {
            _reservationService.ReserveBook(reservation);
            return Ok(reservation);
        }

        [HttpPost("promote/{bookId}")]
        public async Task<IActionResult> PromoteReservation(Guid bookId)
        {
            var promoted = await _reservationService.TryPromoteNextReservationAsync(bookId);
            return promoted ? Ok() : NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult CancelReservation(int id)
        {
            _reservationService.CancelReservation(id);
            return NoContent();
        }

        [HttpPost("assign/{bookId}")]
        public async Task<IActionResult> AssignReservationToBorrow(Guid bookId)
        {  
            Console.WriteLine($"📢 AssignReservationToBorrow çağrıldı: {bookId}");
            await _reservationService.AssignReservationToBorrow(bookId);
            return Ok(new { Message = "Reservation assignment attempted." });
        }
    }
}
