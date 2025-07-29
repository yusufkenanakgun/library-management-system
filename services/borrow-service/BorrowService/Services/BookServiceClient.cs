using BorrowService.Dtos;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace BorrowService.Services
{
    public class BookServiceClient : IBookServiceClient
    {
        private readonly HttpClient _httpClient;

        public BookServiceClient(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<BookDto?> GetBookByIdAsync(Guid bookId)
        {
            var response = await _httpClient.GetAsync($"/api/books/{bookId}");

            if (!response.IsSuccessStatusCode)
            {
                return null;
            }

            var content = await response.Content.ReadAsStringAsync();
            var book = JsonSerializer.Deserialize<BookDto>(content, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            return book;
        }

        // 📦 Yeni metod: isAvailable'ı güncellemek için PATCH isteği
        public async Task<bool> UpdateAvailabilityAsync(Guid bookId, bool isAvailable)
        {
            var updateDto = new { IsAvailable = isAvailable };
            var content = new StringContent(JsonSerializer.Serialize(updateDto), Encoding.UTF8, "application/json");

            var response = await _httpClient.PatchAsync($"/api/books/{bookId}/availability", content);

            return response.IsSuccessStatusCode;
        }
    }
}
