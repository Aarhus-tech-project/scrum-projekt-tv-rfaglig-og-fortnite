using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DotnetBackend.Models.DTOs;
using DotnetBackend.Services;

namespace DotnetBackend.Models.Entities;

public class User
{
    [Key]
    //[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public Guid ID { get; set; }

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

    /*
    public User(RegisterUserDTO registerUserDTO)
    {
        ID = Guid.NewGuid();
        Name = registerUserDTO.Name;
        Email = registerUserDTO.Email;
        PasswordHash = PasswordHasher.HashPassword(registerUserDTO.Password);

        CreatedAt = DateTime.Now;
    }
    */
}