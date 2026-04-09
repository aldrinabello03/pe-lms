using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Web.API.Data;
using Web.API.DTOs;

namespace Web.API.Controllers;

[ApiController]
[Route("api/dashboard")]
[Authorize]
public class DashboardController : ControllerBase
{
    private readonly AppDbContext _db;

    public DashboardController(AppDbContext db)
    {
        _db = db;
    }

    private int GetUserId() => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    private string GetName() => User.FindFirstValue("name") ?? "";

    [HttpGet("student")]
    [Authorize(Roles = "Student")]
    public async Task<IActionResult> GetStudentDashboard()
    {
        var userId = GetUserId();
        return Ok(await BuildDashboard(userId, GetName()));
    }

    [HttpGet("student/{userAccountId:int}")]
    [Authorize(Roles = "Teacher")]
    public async Task<IActionResult> GetStudentDashboardById(int userAccountId)
    {
        var student = await _db.UserAccounts
            .Include(x => x.StudentProfiles)
            .FirstOrDefaultAsync(x => x.Id == userAccountId);

        if (student == null) return NotFound();

        var profile = student.StudentProfiles.FirstOrDefault();
        var name = profile != null ? $"{profile.FirstName} {profile.LastName}" : student.UserName;

        return Ok(await BuildDashboard(userAccountId, name));
    }

    [HttpGet("students")]
    [Authorize(Roles = "Teacher")]
    public async Task<IActionResult> GetAssignedStudents()
    {
        var teacherName = GetName();
        var students = await _db.StudentProfiles
            .Where(x => x.TeacherName == teacherName)
            .ToListAsync();

        var result = students.Select(s => new StudentListItemDto
        {
            UserAccountId = s.UserAccountId,
            ProfileId = s.Id,
            FirstName = s.FirstName,
            LastName = s.LastName,
            MiddleName = s.MiddleName,
            Age = s.Age,
            Gender = s.Gender,
            School = s.School,
            Level = s.Level,
            Section = s.Section,
            StudentNumber = s.StudentNumber,
            TeacherName = s.TeacherName
        });

        return Ok(result);
    }

    private async Task<StudentDashboardDto> BuildDashboard(int userAccountId, string studentName)
    {
        var student = await _db.UserAccounts
            .Include(x => x.Scores)
            .Include(x => x.StudentProfiles)
            .FirstOrDefaultAsync(x => x.Id == userAccountId);

        var vm = new StudentDashboardDto { StudentName = studentName };

        if (student == null) return vm;

        var profile = student.StudentProfiles.FirstOrDefault();
        if (profile != null && !string.IsNullOrEmpty(profile.BodyType))
        {
            vm.Height = profile.Height;
            vm.Weight = profile.Weight;
            vm.BMIInterpretation = profile.BodyType;
        }

        var balanceScore = student.Scores.FirstOrDefault(x => x.TestTitle == "Stork Balance Stand Test");
        if (balanceScore != null)
        {
            vm.BalanceLeft = balanceScore.BalanceLeft;
            vm.BalanceRight = balanceScore.BalanceRight;
            vm.BalanceInterpretation = balanceScore.Interpretation;
        }

        var stepScore = student.Scores.FirstOrDefault(x => x.TestTitle == "3-Minute Step Test");
        if (stepScore != null)
        {
            vm.BeforeHearthRate = stepScore.BeforeHearthRate;
            vm.AfterHearthRate = stepScore.AfterHearthRate;
        }

        var jugglingScore = student.Scores.FirstOrDefault(x => x.TestTitle == "Juggling");
        if (jugglingScore != null)
        {
            vm.JugglingHits = jugglingScore.JugglingHits;
            vm.JugglingInterpretation = jugglingScore.Interpretation;
        }

        var zipperScore = student.Scores.FirstOrDefault(x => x.TestTitle == "Zipper Test");
        if (zipperScore != null)
        {
            vm.ZipperGap = zipperScore.ZipperGap;
            vm.ZipperInterpretation = zipperScore.Interpretation;
        }

        var sitReachScore = student.Scores.FirstOrDefault(x => x.TestTitle == "Sit and Reach");
        if (sitReachScore != null)
        {
            vm.SitAndReachFirstTry = sitReachScore.SitAndReachFirstTry;
            vm.SitAndReachSecondTry = sitReachScore.SitAndReachSecondTry;
            vm.SitAndReachBestScore = (sitReachScore.SitAndReachFirstTry ?? 0) >= (sitReachScore.SitAndReachSecondTry ?? 0)
                ? sitReachScore.SitAndReachFirstTry : sitReachScore.SitAndReachSecondTry;
            vm.SitAndReachInterpretation = sitReachScore.Interpretation;
        }

        var jumpScore = student.Scores.FirstOrDefault(x => x.TestTitle == "Standing Long Jump");
        if (jumpScore != null)
        {
            vm.LongJumpFirstTry = jumpScore.LongJumpFirstTry;
            vm.LongJumpSecondTry = jumpScore.LongJumpSecondTry;
            vm.LongJumpInterpretation = jumpScore.Interpretation;
        }

        var stickScore = student.Scores.FirstOrDefault(x => x.TestTitle == "Stick Drop Test");
        if (stickScore != null)
        {
            vm.StickDrop1 = stickScore.StickDrop1;
            vm.StickDrop2 = stickScore.StickDrop2;
            vm.StickDrop3 = stickScore.StickDrop3;
            vm.StickDropInterpretation = stickScore.Interpretation;
        }

        var pushUpScore = student.Scores.FirstOrDefault(x => x.TestTitle == "Push up");
        if (pushUpScore != null)
        {
            vm.NumberOfPushUps = pushUpScore.NumberOfPushUps;
            vm.PushUpInterpretation = pushUpScore.Interpretation;
        }

        var plankScore = student.Scores.FirstOrDefault(x => x.TestTitle == "Basic Plank");
        if (plankScore != null)
        {
            vm.PlankTime = plankScore.PlankTime;
            vm.PlankInterpretation = plankScore.Interpretation;
        }

        var sprintScore = student.Scores.FirstOrDefault(x => x.TestTitle == "40-Meter Sprint");
        if (sprintScore != null)
        {
            vm.SprintTime = sprintScore.SprintTime;
            vm.SprintInterpretation = sprintScore.Interpretation;
        }

        return vm;
    }
}
