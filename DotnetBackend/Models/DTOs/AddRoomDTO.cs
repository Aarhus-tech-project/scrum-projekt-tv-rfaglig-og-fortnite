using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;

public class AddRoomDTO
{
    public string Name { get; set; } = string.Empty;
    public double Lat { get; set; } = 0.0;
    public double Lon { get; set; } = 0.0;
    public double Alt { get; set; } = 0.0;
    public int Level { get; set; } = 0;

    public AddRoomDTO() { }

    public AddRoomDTO(string name, double lat, double lon, double alt, int level)
    {
        Name = name;
        Lat = lat;
        Lon = lon;
        Alt = alt;
        Level = level;
    }
}