using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Web.API.Data;
using Web.API.DTOs;
using Web.API.Models;

namespace Web.API.Controllers;

[ApiController]
[Route("api/student-profile")]
[Authorize(Roles = "Student")]
public class StudentProfileController : ControllerBase
{
    private readonly AppDbContext _db;

    public StudentProfileController(AppDbContext db)
    {
        _db = db;
    }

    private int GetUserId() => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var userId = GetUserId();
        var profile = await _db.StudentProfiles.FirstOrDefaultAsync(x => x.UserAccountId == userId);
        if (profile == null) return NotFound();
        return Ok(MapToDto(profile));
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] UpdateStudentProfileRequest request)
    {
        var userId = GetUserId();
        var existing = await _db.StudentProfiles.FirstOrDefaultAsync(x => x.UserAccountId == userId);
        if (existing != null)
            return BadRequest(new { message = "Profile already exists. Use PUT to update." });

        var profile = new StudentProfile
        {
            UserAccountId = userId,
            StudentNumber = request.StudentNumber,
            FirstName = request.FirstName,
            LastName = request.LastName,
            MiddleName = request.MiddleName,
            Age = request.Age,
            Gender = request.Gender,
            TeacherName = request.TeacherName,
            School = request.School,
            Level = request.Level,
            Section = request.Section,
            Weight = request.Weight,
            Height = request.Height
        };

        _db.StudentProfiles.Add(profile);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(Get), MapToDto(profile));
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] UpdateStudentProfileRequest request)
    {
        var userId = GetUserId();
        var profile = await _db.StudentProfiles.FirstOrDefaultAsync(x => x.UserAccountId == userId);
        if (profile == null) return NotFound();

        profile.StudentNumber = request.StudentNumber;
        profile.FirstName = request.FirstName;
        profile.LastName = request.LastName;
        profile.MiddleName = request.MiddleName;
        profile.Age = request.Age;
        profile.Gender = request.Gender;
        profile.TeacherName = request.TeacherName;
        profile.School = request.School;
        profile.Level = request.Level;
        profile.Section = request.Section;
        profile.Weight = request.Weight;
        profile.Height = request.Height;

        await _db.SaveChangesAsync();
        return Ok(MapToDto(profile));
    }

    private static StudentProfileDto MapToDto(StudentProfile p) => new()
    {
        Id = p.Id,
        StudentNumber = p.StudentNumber,
        FirstName = p.FirstName,
        LastName = p.LastName,
        MiddleName = p.MiddleName,
        Age = p.Age,
        Gender = p.Gender,
        TeacherName = p.TeacherName,
        School = p.School,
        Level = p.Level,
        Section = p.Section,
        Weight = p.Weight,
        Height = p.Height,
        BodyType = p.BodyType,
        UserAccountId = p.UserAccountId
    };
}
