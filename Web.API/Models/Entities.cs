using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Web.API.Models;

public class UserAccount
{
    [Key]
    public int Id { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string Role { get; set; } = string.Empty;
    public ICollection<StudentScore> Scores { get; set; } = new List<StudentScore>();
    public ICollection<StudentProfile> StudentProfiles { get; set; } = new List<StudentProfile>();
    public ICollection<TeacherProfile> TeacherProfiles { get; set; } = new List<TeacherProfile>();
}

public class StudentProfile
{
    [Key]
    public int Id { get; set; }
    public string? StudentNumber { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? MiddleName { get; set; }
    public int Age { get; set; }
    public string? Gender { get; set; }
    public string? TeacherName { get; set; }
    public string? School { get; set; }
    public string? Level { get; set; }
    public string? Section { get; set; }
    public double Weight { get; set; }
    public double Height { get; set; }
    public string? BodyType { get; set; }
    public int UserAccountId { get; set; }
    public UserAccount? UserAccount { get; set; }
}

public class TeacherProfile
{
    [Key]
    public int Id { get; set; }
    public string? EmployeeNumber { get; set; }
    public string? Title { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? MiddleName { get; set; }
    public string? School { get; set; }
    public int UserAccountId { get; set; }
    public UserAccount? UserAccount { get; set; }
}

public class StudentScore
{
    [Key]
    public int Id { get; set; }
    public int? BeforeHearthRate { get; set; }
    public int? AfterHearthRate { get; set; }
    public int? NumberOfPushUps { get; set; }
    public int? PlankTime { get; set; }
    public double? ZipperGap { get; set; }
    public double? SitAndReachFirstTry { get; set; }
    public double? SitAndReachSecondTry { get; set; }
    public int? JugglingHits { get; set; }
    public int? HexagonClockwise { get; set; }
    public int? HexagonCounterClockwise { get; set; }
    public double? SprintTime { get; set; }
    public int? LongJumpFirstTry { get; set; }
    public int? LongJumpSecondTry { get; set; }
    public int? BalanceRight { get; set; }
    public int? BalanceLeft { get; set; }
    public double? StickDrop1 { get; set; }
    public double? StickDrop2 { get; set; }
    public double? StickDrop3 { get; set; }
    public string? TestTitle { get; set; }
    public string? Interpretation { get; set; }
    public int UserAccountId { get; set; }
    public UserAccount? UserAccount { get; set; }
}
