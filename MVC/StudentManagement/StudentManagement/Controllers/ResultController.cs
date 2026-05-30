using Microsoft.AspNetCore.Mvc;
using StudentManagement.Models;
using System.Linq;

namespace StudentManagement.Controllers
{
    [Route("api")]
    [ApiController]
    public class ResultController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ResultController(AppDbContext context)
        {
            _context = context;
        }

        // API Lấy kết quả học tập theo UserID
        [HttpGet("results/{userID}")]
        public IActionResult GetResults(int userID)
        {
            var results = _context.Results.Where(r => r.UserID == userID).ToList();
            return Ok(results);
        }
    }
}