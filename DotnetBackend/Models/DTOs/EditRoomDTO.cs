using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;

public class EditRoomDTO
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public double Lat { get; set; } = 0.0;
    public double Lon { get; set; } = 0.0;
    public double Alt { get; set; } = 0.0;
    public int Level { get; set; } = 0;

    public EditRoomDTO() { }

    public EditRoomDTO(Guid id, string name, double lat, double lon, double alt, int level)
    {
        Id = id;
        Name = name;
        Lat = lat;
        Lon = lon;
        Alt = alt;
        Level = level;
    }
}
