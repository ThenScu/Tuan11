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
        // 2. API Đăng ký
        [HttpPost("register")]
        public IActionResult Register([FromBody] RegisterModel model)
        {
            // Kiểm tra xem user/email tồn tại chưa 
            if (_context.Users.Any(u => u.Username == model.Username || u.Email == model.Email))
            {
                return BadRequest("Tên đăng nhập hoặc Email đã tồn tại!");
            }

            var user = new User
            {
                FullName = model.FullName,
                Username = model.Username,
                Password = model.Password,
                PhoneNumber = model.PhoneNumber,
                Address = model.Address,
                Email = model.Email,
                DateOfBirth = model.DateOfBirth
            };

            _context.Users.Add(user);
            _context.SaveChanges();

            return Ok();
        }

        // 3. API Quên mật khẩu
        [HttpPost("forgot-password")]
        public IActionResult ForgotPassword([FromBody] ForgotPasswordModel model)
        {
            var user = _context.Users.FirstOrDefault(u => u.Email == model.Email);
            if (user == null)
                return NotFound("Không tìm thấy email này trong hệ thống.");

            return Ok();
        }

    }
}