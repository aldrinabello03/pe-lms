namespace Web.API.DTOs;

public class TestListItemDto
{
    public int Order { get; set; }
    public string TestKey { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public bool IsCompleted { get; set; }
}

public class TestDetailDto
{
    public string TestKey { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string? Purpose { get; set; }
    public string? Formula { get; set; }
    public string? Equipment { get; set; }
    public string? ProcedureTester { get; set; }
    public string? ProcedurePartner { get; set; }
    public string? Scoring { get; set; }
    public string? VideoUrl { get; set; }
    public string? NextTestKey { get; set; }
    public string? PreviousTestKey { get; set; }
}
