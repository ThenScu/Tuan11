using Microsoft.AspNetCore.Mvc;
using StudentManagement.Models;
using System.Linq;

namespace StudentManagement.Controllers
{
    [Route("api")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        // 1. API Đăng nhập
        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginModel model)
        {
            var user = _context.Users.FirstOrDefault(u => u.Username == model.Username && u.Password == model.Password);
            if (user == null)
                return Unauthorized();

            return Ok(new { UserID = user.UserID, FullName = user.FullName });
        }

       
    }
}