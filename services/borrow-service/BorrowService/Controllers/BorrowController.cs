using BorrowService.Models;
using BorrowService.Services;
using Microsoft.AspNetCore.Mvc;
using BorrowService.Dtos;

namespace BorrowService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BorrowController : ControllerBase
    {
        private readonly IBorrowService _borrowService;
        private readonly IBookServiceClient _bookServiceClient;

        public BorrowController(IBorrowService borrowService, IBookServiceClient bookServiceClient)
        {
            _borrowService = borrowService;
            _bookServiceClient = bookServiceClient;
        }

        [HttpGet]
        public async Task<ActionResult<List<Borrow>>> GetAll()
        {
            var borrows = await _borrowService.GetAllAsync();
            return Ok(borrows);
        }

        [HttpGet("user/{username}")]
public async Task<ActionResult<IEnumerable<Borrow>>> GetByUsername(string username)
{
    var borrows = await _borrowService.GetByUsernameAsync(username);
    return Ok(borrows);
}


        [HttpGet("{id}")]
        public async Task<ActionResult<Borrow>> GetById(int id)
        {
            var borrow = await _borrowService.GetByIdAsync(id);
            if (borrow == null)
                return NotFound();
            return Ok(borrow);
        }

        [HttpPost]
        public async Task<IActionResult> BorrowBook([FromBody] BorrowRequestDto request)
        {
            var borrow = await _borrowService.BorrowBookAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = borrow.Id }, borrow);
        }

        [HttpPut("{id}/return")]
        public async Task<IActionResult> ReturnBook(int id)
        {
            var updated = await _borrowService.ReturnBookAsync(id);
            if (!updated)
                return NotFound();

            return NoContent();
        }

        [HttpGet("{id}/with-book")]
        public async Task<IActionResult> GetBorrowWithBookDetails(int id)
        {
            var borrow = await _borrowService.GetByIdAsync(id);
            if (borrow == null)
                return NotFound();

            BookDto? book = null;

            try
            {
                book = await _bookServiceClient.GetBookByIdAsync(borrow.BookId);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching book: {ex.Message}");
            }

            return Ok(new
            {
                Borrow = borrow,
                Book = book
            });
        }

        [HttpPost("notify-upcoming")]
public async Task<IActionResult> NotifyUpcomingReturns()
{
    await _borrowService.SendDueNotificationsAsync();
    return Ok("Bildirimler gönderildi.");
}


        [HttpGet("book/{bookId}")]
        public async Task<ActionResult<Borrow>> GetLastBorrowByBookId(Guid bookId)
        {
            var borrow = await _borrowService.GetLastBorrowByBookIdAsync(bookId);
            if (borrow == null)
                return NotFound();
            return Ok(borrow);
        }
    }
}
