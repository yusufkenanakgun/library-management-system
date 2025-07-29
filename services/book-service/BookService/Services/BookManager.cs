using BookService.Models;
using BookService.Data; 
using Microsoft.EntityFrameworkCore;

namespace BookService.Services
{
    public class BookManager : IBookService
    {
        private readonly AppDbContext _context;

        public BookManager(AppDbContext context)
        {
            _context = context;
        }

        public List<Book> GetAll()
        {
            return _context.Books.ToList();
        }

        public Book? GetById(Guid id)
        {
            return _context.Books.Find(id);
        }

        public void Add(Book book)
        {
            _context.Books.Add(book);
            _context.SaveChanges();
        }

        public void Update(Book book)
        {
            _context.Books.Update(book);
            _context.SaveChanges();
        }

        public void Delete(Guid id)
        {
            var book = _context.Books.Find(id);
            if (book != null)
            {
                _context.Books.Remove(book);
                _context.SaveChanges();
            }
        }

        // ✨ YENİ - Sadece isAvailable değiştirme
        public void UpdateAvailability(Guid id, bool isAvailable)
        {
            var book = _context.Books.Find(id);
            if (book != null)
            {
                book.IsAvailable = isAvailable;
                _context.SaveChanges();
            }
        }
    }
}
