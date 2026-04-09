namespace Web.API.DTOs;

public class StudentProfileDto
{
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
}

public class UpdateStudentProfileRequest
{
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
}

public class TeacherProfileDto
{
    public int Id { get; set; }
    public string? EmployeeNumber { get; set; }
    public string? Title { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? MiddleName { get; set; }
    public string? School { get; set; }
    public int UserAccountId { get; set; }
}

public class UpdateTeacherProfileRequest
{
    public string? EmployeeNumber { get; set; }
    public string? Title { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? MiddleName { get; set; }
    public string? School { get; set; }
}
