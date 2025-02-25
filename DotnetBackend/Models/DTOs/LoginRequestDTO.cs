namespace DotnetBackend.Models.DTOs;

public class LoginRequestDTO : IDisposable
{
    public string Email { get; set; }
    public string Password { get; set; }

    public void Dispose()
    {
        Email = string.Empty;
        Password = string.Empty;
    }
}