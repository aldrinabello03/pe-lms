namespace Web.API.DTOs;

public record LoginRequest(string UserName, string Password);

public record RegisterRequest(string UserName, string Password, string ConfirmPassword, string Role);

public record LoginResponse(
    string Token,
    int UserId,
    string UserName,
    string Role,
    string Name,
    int Age,
    string Gender,
    int ProfileId
);
