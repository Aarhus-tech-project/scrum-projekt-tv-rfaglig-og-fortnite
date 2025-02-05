using System.ComponentModel.DataAnnotations;

namespace DotNetBackend.Models;

public class User
{
    [Key]
    public int ID { get; set; }

    [Required]
    [StringLength(64)]
    public string Name { get; set; }

    [Required]
    [StringLength(128)]
    public string Email { get; set; }

    [Required]
    [StringLength(128)]
    public string PasswordHash { get; set; }

    [Required]
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