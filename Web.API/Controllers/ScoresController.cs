using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Web.API.Data;
using Web.API.DTOs;
using Web.API.Models;
using Web.API.Services;

namespace Web.API.Controllers;

[ApiController]
[Route("api/scores")]
[Authorize(Roles = "Student")]
public class ScoresController : ControllerBase
{
    private readonly AppDbContext _db;

    public ScoresController(AppDbContext db)
    {
        _db = db;
    }

    private int GetUserId() => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    private int GetAge() => int.TryParse(User.FindFirstValue("age"), out var a) ? a : 0;
    private string GetGender() => User.FindFirstValue("gender") ?? "";
    private int GetProfileId() => int.TryParse(User.FindFirstValue("profileId"), out var p) ? p : 0;

    [HttpPost]
    public async Task<IActionResult> Submit([FromBody] SubmitScoreRequest request)
    {
        var userId = GetUserId();
        var age = GetAge();
        var gender = GetGender();
        var profileId = GetProfileId();

        if (request.TestTitle == "Body Mass Index")
        {
            if (request.Weight == null || request.Height == null || request.Height == 0)
                return BadRequest(new { message = "Weight and Height are required for BMI." });

            var bmi = request.Weight.Value / (request.Height.Value * request.Height.Value);
            var classification = InterpretationService.ComputeBmiClassification(bmi);
            var bodyType = $"{Math.Round(bmi, 2)} - {classification}";

            var profile = await _db.StudentProfiles.FirstOrDefaultAsync(x => x.Id == profileId);
            if (profile == null)
                return BadRequest(new { message = "Student profile not found." });

            profile.Weight = request.Weight.Value;
            profile.Height = request.Height.Value;
            profile.BodyType = bodyType;
            await _db.SaveChangesAsync();

            return Ok(new { interpretation = bodyType });
        }

        string interpretation = request.TestTitle switch
        {
            "Stork Balance Stand Test" => InterpretationService.ComputeBalance(request.BalanceLeft, request.BalanceRight, age),
            "3-Minute Step Test" => "",
            "Juggling" => InterpretationService.ComputeJuggling(request.JugglingHits),
            "Zipper Test" => InterpretationService.ComputeZipper(request.ZipperGap),
            "Sit and Reach" => InterpretationService.ComputeSitAndReach(request.SitAndReachFirstTry, request.SitAndReachSecondTry),
            "Standing Long Jump" => InterpretationService.ComputeLongJump(request.LongJumpFirstTry, request.LongJumpSecondTry),
            "Stick Drop Test" => InterpretationService.ComputeStickDrop(request.StickDrop1, request.StickDrop2, request.StickDrop3),
            "Push up" => InterpretationService.ComputePushUp(request.NumberOfPushUps, gender),
            "Basic Plank" => InterpretationService.ComputePlank(request.PlankTime),
            "40-Meter Sprint" => InterpretationService.ComputeSprint(request.SprintTime, gender, age),
            _ => ""
        };

        var existing = await _db.StudentScores.FirstOrDefaultAsync(x => x.UserAccountId == userId && x.TestTitle == request.TestTitle);
        if (existing != null)
        {
            existing.BeforeHearthRate = request.BeforeHearthRate;
            existing.AfterHearthRate = request.AfterHearthRate;
            existing.NumberOfPushUps = request.NumberOfPushUps;
            existing.PlankTime = request.PlankTime;
            existing.ZipperGap = request.ZipperGap;
            existing.SitAndReachFirstTry = request.SitAndReachFirstTry;
            existing.SitAndReachSecondTry = request.SitAndReachSecondTry;
            existing.JugglingHits = request.JugglingHits;
            existing.HexagonClockwise = request.HexagonClockwise;
            existing.HexagonCounterClockwise = request.HexagonCounterClockwise;
            existing.SprintTime = request.SprintTime;
            existing.LongJumpFirstTry = request.LongJumpFirstTry;
            existing.LongJumpSecondTry = request.LongJumpSecondTry;
            existing.BalanceRight = request.BalanceRight;
            existing.BalanceLeft = request.BalanceLeft;
            existing.StickDrop1 = request.StickDrop1;
            existing.StickDrop2 = request.StickDrop2;
            existing.StickDrop3 = request.StickDrop3;
            existing.Interpretation = interpretation;
            await _db.SaveChangesAsync();
            return Ok(new { id = existing.Id, interpretation });
        }

        var score = new StudentScore
        {
            UserAccountId = userId,
            TestTitle = request.TestTitle,
            BeforeHearthRate = request.BeforeHearthRate,
            AfterHearthRate = request.AfterHearthRate,
            NumberOfPushUps = request.NumberOfPushUps,
            PlankTime = request.PlankTime,
            ZipperGap = request.ZipperGap,
            SitAndReachFirstTry = request.SitAndReachFirstTry,
            SitAndReachSecondTry = request.SitAndReachSecondTry,
            JugglingHits = request.JugglingHits,
            HexagonClockwise = request.HexagonClockwise,
            HexagonCounterClockwise = request.HexagonCounterClockwise,
            SprintTime = request.SprintTime,
            LongJumpFirstTry = request.LongJumpFirstTry,
            LongJumpSecondTry = request.LongJumpSecondTry,
            BalanceRight = request.BalanceRight,
            BalanceLeft = request.BalanceLeft,
            StickDrop1 = request.StickDrop1,
            StickDrop2 = request.StickDrop2,
            StickDrop3 = request.StickDrop3,
            Interpretation = interpretation
        };

        _db.StudentScores.Add(score);
        await _db.SaveChangesAsync();
        return Ok(new { id = score.Id, interpretation });
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var userId = GetUserId();
        var scores = await _db.StudentScores.Where(x => x.UserAccountId == userId).ToListAsync();
        return Ok(scores.Select(MapToDto));
    }

    [HttpGet("{testTitle}")]
    public async Task<IActionResult> GetByTitle(string testTitle)
    {
        var userId = GetUserId();
        var score = await _db.StudentScores.FirstOrDefaultAsync(x => x.UserAccountId == userId && x.TestTitle == testTitle);
        if (score == null) return NotFound();
        return Ok(MapToDto(score));
    }

    private static ScoreDto MapToDto(StudentScore s) => new()
    {
        Id = s.Id,
        TestTitle = s.TestTitle,
        Interpretation = s.Interpretation,
        BeforeHearthRate = s.BeforeHearthRate,
        AfterHearthRate = s.AfterHearthRate,
        NumberOfPushUps = s.NumberOfPushUps,
        PlankTime = s.PlankTime,
        ZipperGap = s.ZipperGap,
        SitAndReachFirstTry = s.SitAndReachFirstTry,
        SitAndReachSecondTry = s.SitAndReachSecondTry,
        JugglingHits = s.JugglingHits,
        SprintTime = s.SprintTime,
        LongJumpFirstTry = s.LongJumpFirstTry,
        LongJumpSecondTry = s.LongJumpSecondTry,
        BalanceRight = s.BalanceRight,
        BalanceLeft = s.BalanceLeft,
        StickDrop1 = s.StickDrop1,
        StickDrop2 = s.StickDrop2,
        StickDrop3 = s.StickDrop3
    };
}
