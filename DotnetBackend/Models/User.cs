namespace DotNetBackend.Models;

public class User
{
    public int ID { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    public string PasswordHash { get; set; }
    public DateTime CreatedAt { get; set; }

    public User(){}

    public User(RegisterUserDTO registerUserDTO)
    {
        Name = registerUserDTO.Name;
        Email = registerUserDTO.Email;
        PasswordHash = PasswordHasher.HashPassword(registerUserDTO.Password);

        CreatedAt = DateTime.Now;
    }
}