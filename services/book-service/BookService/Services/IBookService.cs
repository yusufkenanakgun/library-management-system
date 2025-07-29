using BookService.Models;
using System.Collections.Generic;

namespace BookService.Services
{
    public interface IBookService
    {
        List<Book> GetAll();
        Book? GetById(Guid id);
        void Add(Book book);
        void Update(Book book);
        void Delete(Guid id);

        // ✨ Yeni eklenen
        void UpdateAvailability(Guid id, bool isAvailable);
    }
}
