namespace DotnetBackend.Models.DTOs;

public class RegisterUserDTO : IDisposable
{
    public string Name { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }

    public void Dispose()
    {
        Name = string.Empty;
        Email = string.Empty;
        Password = string.Empty;
    }
}