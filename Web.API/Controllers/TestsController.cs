using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using System.Text.Json;
using Web.API.Data;
using Web.API.DTOs;

namespace Web.API.Controllers;

[ApiController]
[Route("api/tests")]
[Authorize(Roles = "Student")]
public class TestsController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly IWebHostEnvironment _env;

    private static readonly (string Key, string Title, int Order)[] TestOrder = new[]
    {
        ("Body Composition", "Body Mass Index", 1),
        ("Balance", "Stork Balance Stand Test", 2),
        ("Cardio Vascular Endurance", "3-Minute Step Test", 3),
        ("Coordination", "Juggling", 4),
        ("Flexibility1", "Zipper Test", 5),
        ("Flexibility2", "Sit and Reach", 6),
        ("Strength1", "Push up", 7),
        ("Strength2", "Basic Plank", 8),
        ("Power", "Standing Long Jump", 9),
        ("Reaction Time", "Stick Drop Test", 10),
        ("Test for Speed", "40-Meter Sprint", 11)
    };

    private static readonly Dictionary<string, string> NavigationMap = new()
    {
        ["Body Composition"] = "Balance",
        ["Balance"] = "Cardio Vascular Endurance",
        ["Cardio Vascular Endurance"] = "Coordination",
        ["Coordination"] = "Flexibility1",
        ["Flexibility1"] = "Flexibility2",
        ["Flexibility2"] = "Strength1",
        ["Strength1"] = "Strength2",
        ["Strength2"] = "Power",
        ["Power"] = "Reaction Time",
        ["Reaction Time"] = "Test for Speed",
        ["Test for Speed"] = "Body Composition"
    };

    public TestsController(AppDbContext db, IWebHostEnvironment env)
    {
        _db = db;
        _env = env;
    }

    private int GetUserId() => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var userId = GetUserId();
        var user = await _db.UserAccounts
            .Include(x => x.Scores)
            .Include(x => x.StudentProfiles)
            .FirstOrDefaultAsync(x => x.Id == userId);

        var result = TestOrder.Select(t =>
        {
            bool isDone = false;
            if (user != null)
            {
                if (t.Title == "Body Mass Index")
                    isDone = user.StudentProfiles.Any(p => !string.IsNullOrEmpty(p.BodyType));
                else
                    isDone = user.Scores.Any(s => s.TestTitle == t.Title);
            }
            return new TestListItemDto
            {
                Order = t.Order,
                TestKey = t.Key,
                Title = t.Title,
                IsCompleted = isDone
            };
        }).ToList();

        return Ok(result);
    }

    [HttpGet("{testKey}")]
    public IActionResult GetDetail(string testKey)
    {
        var videoData = LoadVideoDescriptions();
        if (videoData == null) return StatusCode(500, "Could not load test data.");

        if (!videoData.Value.TryGetProperty(testKey, out var info))
            return NotFound(new { message = $"Test '{testKey}' not found." });

        string title = info.TryGetProperty("title", out var t) ? t.GetString() ?? "" : "";

        string? purpose = info.TryGetProperty("Purpose", out var p) ? p.GetString() : null;
        string? formula = info.TryGetProperty("Formula", out var f) ? f.GetString() : null;

        string? equipment = null;
        if (info.TryGetProperty("Equipment", out var eq) && eq.ValueKind == JsonValueKind.Array)
            equipment = string.Join(", ", eq.EnumerateArray().Select(e => e.GetString()));

        string? procedureTester = null;
        string? procedurePartner = null;
        if (info.TryGetProperty("Procedure", out var proc))
        {
            if (proc.TryGetProperty("For the Tester", out var tester) && tester.ValueKind == JsonValueKind.Array)
                procedureTester = string.Join("\n", tester.EnumerateArray().Select(e => e.GetString()));
            if (proc.TryGetProperty("For the Partner", out var partner) && partner.ValueKind == JsonValueKind.Array)
                procedurePartner = string.Join("\n", partner.EnumerateArray().Select(e => e.GetString()));
        }

        string? scoring = info.TryGetProperty("Scoring", out var sc) ? sc.GetString() : null;

        string videoUrl;
        if (testKey is "Flexibility1" or "Flexibility2")
            videoUrl = "videos/Flexibility.mp4";
        else if (testKey is "Strength1" or "Strength2")
            videoUrl = "videos/Strength.mp4";
        else
            videoUrl = $"videos/{testKey}.mp4";

        string? nextKey = NavigationMap.TryGetValue(testKey, out var n) ? n : null;
        string? prevKey = NavigationMap.FirstOrDefault(kv => kv.Value == testKey).Key;

        return Ok(new TestDetailDto
        {
            TestKey = testKey,
            Title = title,
            Purpose = purpose,
            Formula = formula,
            Equipment = equipment,
            ProcedureTester = procedureTester,
            ProcedurePartner = procedurePartner,
            Scoring = scoring,
            VideoUrl = videoUrl,
            NextTestKey = nextKey,
            PreviousTestKey = prevKey
        });
    }

    private JsonElement? LoadVideoDescriptions()
    {
        var path = Path.Combine(_env.ContentRootPath, "Data", "VideoDescriptions.json");
        if (!System.IO.File.Exists(path)) return null;
        var json = System.IO.File.ReadAllText(path);
        var doc = JsonDocument.Parse(json);
        return doc.RootElement;
    }
}
