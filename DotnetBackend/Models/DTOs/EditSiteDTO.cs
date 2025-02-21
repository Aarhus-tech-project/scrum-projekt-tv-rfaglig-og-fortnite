using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;
public class EditSiteDTO
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public bool IsPublic { get; set; } = true;

    public List<EditRoomDTO> Rooms { get; set; } = new();
    public List<AddEditUserSiteDTO> Users { get; set; } = new();
}
