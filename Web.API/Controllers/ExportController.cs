using ClosedXML.Excel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Web.API.Data;

namespace Web.API.Controllers;

[ApiController]
[Route("api/export")]
[Authorize(Roles = "Teacher")]
public class ExportController : ControllerBase
{
    private readonly AppDbContext _db;

    public ExportController(AppDbContext db)
    {
        _db = db;
    }

    private string GetName() => User.FindFirstValue("name") ?? "";

    [HttpGet("student/{userAccountId:int}")]
    public async Task<IActionResult> ExportStudent(int userAccountId)
    {
        var student = await _db.UserAccounts
            .Include(x => x.Scores)
            .Include(x => x.StudentProfiles)
            .FirstOrDefaultAsync(x => x.Id == userAccountId);

        if (student == null) return NotFound();

        using var wb = new XLWorkbook();
        AddStudentSheet(wb, student);

        using var ms = new MemoryStream();
        wb.SaveAs(ms);
        ms.Position = 0;

        var profile = student.StudentProfiles.FirstOrDefault();
        var fileName = profile != null
            ? $"{profile.LastName}_{profile.FirstName}_scores.xlsx"
            : $"student_{userAccountId}_scores.xlsx";

        return File(ms.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
    }

    [HttpGet("students")]
    public async Task<IActionResult> ExportAllStudents()
    {
        var teacherName = GetName();
        var assignedProfiles = await _db.StudentProfiles
            .Where(x => x.TeacherName == teacherName)
            .Select(x => x.UserAccountId)
            .ToListAsync();

        var students = await _db.UserAccounts
            .Include(x => x.Scores)
            .Include(x => x.StudentProfiles)
            .Where(x => assignedProfiles.Contains(x.Id))
            .ToListAsync();

        using var wb = new XLWorkbook();
        foreach (var student in students)
            AddStudentSheet(wb, student);

        using var ms = new MemoryStream();
        wb.SaveAs(ms);
        ms.Position = 0;

        return File(ms.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "students_scores.xlsx");
    }

    private static void AddStudentSheet(XLWorkbook wb, Web.API.Models.UserAccount student)
    {
        var profile = student.StudentProfiles.FirstOrDefault();
        var sheetName = profile != null
            ? $"{profile.LastName}, {profile.FirstName}"[..Math.Min(31, $"{profile.LastName}, {profile.FirstName}".Length)]
            : $"Student {student.Id}";

        var ws = wb.Worksheets.Add(sheetName);

        ws.Cell(1, 1).Value = "Test";
        ws.Cell(1, 2).Value = "Score/Details";
        ws.Cell(1, 3).Value = "Interpretation";
        ws.Row(1).Style.Font.Bold = true;

        int row = 2;

        if (profile != null && !string.IsNullOrEmpty(profile.BodyType))
        {
            ws.Cell(row, 1).Value = "Body Mass Index";
            ws.Cell(row, 2).Value = $"Weight: {profile.Weight}kg, Height: {profile.Height}m";
            ws.Cell(row, 3).Value = profile.BodyType;
            row++;
        }

        var testTitles = new[]
        {
            "Stork Balance Stand Test", "3-Minute Step Test", "Juggling", "Zipper Test",
            "Sit and Reach", "Standing Long Jump", "Stick Drop Test", "Push up",
            "Basic Plank", "40-Meter Sprint"
        };

        foreach (var title in testTitles)
        {
            var score = student.Scores.FirstOrDefault(s => s.TestTitle == title);
            if (score == null) continue;

            ws.Cell(row, 1).Value = title;
            ws.Cell(row, 2).Value = GetScoreDetails(score, title);
            ws.Cell(row, 3).Value = score.Interpretation ?? "";
            row++;
        }

        ws.Columns().AdjustToContents();
    }

    private static string GetScoreDetails(Web.API.Models.StudentScore score, string title) => title switch
    {
        "Stork Balance Stand Test" => $"Left: {score.BalanceLeft}s, Right: {score.BalanceRight}s",
        "3-Minute Step Test" => $"Before HR: {score.BeforeHearthRate}, After HR: {score.AfterHearthRate}",
        "Juggling" => $"Hits: {score.JugglingHits}",
        "Zipper Test" => $"Gap: {score.ZipperGap}cm",
        "Sit and Reach" => $"Try 1: {score.SitAndReachFirstTry}cm, Try 2: {score.SitAndReachSecondTry}cm",
        "Standing Long Jump" => $"Try 1: {score.LongJumpFirstTry}cm, Try 2: {score.LongJumpSecondTry}cm",
        "Stick Drop Test" => $"Drop 1: {score.StickDrop1}cm, Drop 2: {score.StickDrop2}cm, Drop 3: {score.StickDrop3}cm",
        "Push up" => $"Reps: {score.NumberOfPushUps}",
        "Basic Plank" => $"Time: {score.PlankTime}s",
        "40-Meter Sprint" => $"Time: {score.SprintTime}s",
        _ => ""
    };
}
