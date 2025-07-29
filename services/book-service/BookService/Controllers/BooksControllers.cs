using BookService.Models;
using BookService.Services;
using Microsoft.AspNetCore.Mvc;
using BookService.Dtos; // 📌 Ekledik!

namespace BookService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase
{
    private readonly IBookService _bookService;

    public BooksController(IBookService bookService)
    {
        _bookService = bookService;
    }

    [HttpGet]
    public ActionResult<List<Book>> GetAll() => _bookService.GetAll();

    [HttpGet("{id}")]
    public ActionResult<Book> GetById(Guid id)
    {
        var book = _bookService.GetById(id);
        return book == null ? NotFound() : Ok(book);
    }

    [HttpPost]
    public IActionResult Add(Book book)
    {
        _bookService.Add(book);
        return CreatedAtAction(nameof(GetById), new { id = book.Id }, book);
    }

    [HttpPut("{id}")]
    public IActionResult Update(Guid id, Book updatedBook)
    {
        var book = _bookService.GetById(id);
        if (book == null)
            return NotFound();

        updatedBook.Id = id;
        _bookService.Update(updatedBook);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(Guid id)
    {
        var book = _bookService.GetById(id);
        if (book == null)
            return NotFound();

        _bookService.Delete(id);
        return NoContent();
    }

    // ✨ YENİ PATCH endpoint
    [HttpPatch("{id}/availability")]
    public IActionResult UpdateAvailability(Guid id, [FromBody] UpdateAvailabilityDto updateDto)
    {
        var book = _bookService.GetById(id);
        if (book == null)
            return NotFound();

        _bookService.UpdateAvailability(id, updateDto.IsAvailable);
        return NoContent();
    }
}
