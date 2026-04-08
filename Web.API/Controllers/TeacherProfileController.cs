using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Web.API.Data;
using Web.API.DTOs;
using Web.API.Models;

namespace Web.API.Controllers;

[ApiController]
[Route("api/teacher-profile")]
[Authorize(Roles = "Teacher")]
public class TeacherProfileController : ControllerBase
{
    private readonly AppDbContext _db;

    public TeacherProfileController(AppDbContext db)
    {
        _db = db;
    }

    private int GetUserId() => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var userId = GetUserId();
        var profile = await _db.TeacherProfiles.FirstOrDefaultAsync(x => x.UserAccountId == userId);
        if (profile == null) return NotFound();
        return Ok(MapToDto(profile));
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] UpdateTeacherProfileRequest request)
    {
        var userId = GetUserId();
        var existing = await _db.TeacherProfiles.FirstOrDefaultAsync(x => x.UserAccountId == userId);
        if (existing != null)
            return BadRequest(new { message = "Profile already exists. Use PUT to update." });

        var profile = new TeacherProfile
        {
            UserAccountId = userId,
            EmployeeNumber = request.EmployeeNumber,
            Title = request.Title,
            FirstName = request.FirstName,
            LastName = request.LastName,
            MiddleName = request.MiddleName,
            School = request.School
        };

        _db.TeacherProfiles.Add(profile);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(Get), MapToDto(profile));
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] UpdateTeacherProfileRequest request)
    {
        var userId = GetUserId();
        var profile = await _db.TeacherProfiles.FirstOrDefaultAsync(x => x.UserAccountId == userId);
        if (profile == null) return NotFound();

        profile.EmployeeNumber = request.EmployeeNumber;
        profile.Title = request.Title;
        profile.FirstName = request.FirstName;
        profile.LastName = request.LastName;
        profile.MiddleName = request.MiddleName;
        profile.School = request.School;

        await _db.SaveChangesAsync();
        return Ok(MapToDto(profile));
    }

    private static TeacherProfileDto MapToDto(TeacherProfile p) => new()
    {
        Id = p.Id,
        EmployeeNumber = p.EmployeeNumber,
        Title = p.Title,
        FirstName = p.FirstName,
        LastName = p.LastName,
        MiddleName = p.MiddleName,
        School = p.School,
        UserAccountId = p.UserAccountId
    };
}
