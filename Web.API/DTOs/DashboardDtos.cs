namespace Web.API.DTOs;

public class StudentDashboardDto
{
    public string? StudentName { get; set; }
    public double? Height { get; set; }
    public double? Weight { get; set; }
    public string? BMIInterpretation { get; set; }
    public int? BalanceLeft { get; set; }
    public int? BalanceRight { get; set; }
    public string? BalanceInterpretation { get; set; }
    public int? BeforeHearthRate { get; set; }
    public int? AfterHearthRate { get; set; }
    public int? JugglingHits { get; set; }
    public string? JugglingInterpretation { get; set; }
    public double? ZipperGap { get; set; }
    public string? ZipperInterpretation { get; set; }
    public double? SitAndReachFirstTry { get; set; }
    public double? SitAndReachSecondTry { get; set; }
    public double? SitAndReachBestScore { get; set; }
    public string? SitAndReachInterpretation { get; set; }
    public int? LongJumpFirstTry { get; set; }
    public int? LongJumpSecondTry { get; set; }
    public string? LongJumpInterpretation { get; set; }
    public double? StickDrop1 { get; set; }
    public double? StickDrop2 { get; set; }
    public double? StickDrop3 { get; set; }
    public string? StickDropInterpretation { get; set; }
    public int? NumberOfPushUps { get; set; }
    public string? PushUpInterpretation { get; set; }
    public int? PlankTime { get; set; }
    public string? PlankInterpretation { get; set; }
    public double? SprintTime { get; set; }
    public string? SprintInterpretation { get; set; }
}

public class StudentListItemDto
{
    public int UserAccountId { get; set; }
    public int ProfileId { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? MiddleName { get; set; }
    public int Age { get; set; }
    public string? Gender { get; set; }
    public string? School { get; set; }
    public string? Level { get; set; }
    public string? Section { get; set; }
    public string? StudentNumber { get; set; }
    public string? TeacherName { get; set; }
}
