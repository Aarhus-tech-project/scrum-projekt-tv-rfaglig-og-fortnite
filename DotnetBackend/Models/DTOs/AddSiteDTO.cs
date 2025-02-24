using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;

public class AddSiteDTO
{
    public string Name { get; set; } = string.Empty;
    public double Lat { get; set; }
    public double Lon { get; set; }
    public double Alt { get; set; }
    public string Address { get; set; } = string.Empty;
    public bool IsPublic { get; set; } = true;

    public List<AddRoomDTO> Rooms { get; set; } = new();
    public List<AddEditUserSiteDTO> Users { get; set; } = new();
}