using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;

public class AddEditUserSiteDTO
{
    public string Email { get; set; } = string.Empty;
    public UserRole Role { get; set; } = UserRole.Normal;

    public AddEditUserSiteDTO() { }

    public AddEditUserSiteDTO(string email, UserRole role)
    {
        Email = email;
        Role = role;
    }
}
