using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Web.API.Data;
using Web.API.DTOs;
using Web.API.Models;

namespace Web.API.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly IConfiguration _config;

    public AuthController(AppDbContext db, IConfiguration config)
    {
        _db = db;
        _config = config;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var user = await _db.UserAccounts
            .FirstOrDefaultAsync(x => x.UserName == request.UserName && x.Password == request.Password);

        if (user == null)
            return Unauthorized(new { message = "Invalid username or password." });

        string name = user.UserName;
        int age = 0;
        int profileId = 0;
        string gender = "";

        if (user.Role == "Student")
        {
            var profile = await _db.StudentProfiles.FirstOrDefaultAsync(x => x.UserAccountId == user.Id);
            if (profile != null)
            {
                name = $"{profile.FirstName} {profile.LastName}";
                age = profile.Age;
                profileId = profile.Id;
                gender = profile.Gender ?? "";
            }
        }
        else if (user.Role == "Teacher")
        {
            var profile = await _db.TeacherProfiles.FirstOrDefaultAsync(x => x.UserAccountId == user.Id);
            if (profile != null)
            {
                name = $"{profile.FirstName} {profile.LastName}";
                profileId = profile.Id;
            }
        }

        var token = GenerateToken(user.Id, user.Role, name, age, gender, profileId);

        return Ok(new LoginResponse(token, user.Id, user.UserName, user.Role, name, age, gender, profileId));
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        if (request.Password != request.ConfirmPassword)
            return BadRequest(new { message = "Passwords do not match." });

        var exists = await _db.UserAccounts.AnyAsync(x => x.UserName == request.UserName);
        if (exists)
            return BadRequest(new { message = "Username already taken." });

        var user = new UserAccount
        {
            UserName = request.UserName,
            Password = request.Password,
            Role = request.Role
        };

        _db.UserAccounts.Add(user);
        await _db.SaveChangesAsync();

        return Ok(new { message = "Registration successful.", userId = user.Id });
    }

    private string GenerateToken(int userId, string role, string name, int age, string gender, int profileId)
    {
        var jwtKey = _config["Jwt:Key"] ?? "default-secret-key-that-is-at-least-32-chars!!";
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, userId.ToString()),
            new Claim(ClaimTypes.Role, role),
            new Claim("name", name),
            new Claim("age", age.ToString()),
            new Claim("gender", gender),
            new Claim("profileId", profileId.ToString())
        };

        var token = new JwtSecurityToken(
            issuer: _config["Jwt:Issuer"],
            audience: _config["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddDays(7),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
