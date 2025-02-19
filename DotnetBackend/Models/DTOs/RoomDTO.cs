using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;

public class RoomDTO
{
    public string Name { get; set; }
    public double Lat { get; set; }
    public double Lon { get; set; }
    public double Alt { get; set; }
    public int Level { get; set; }
    public string SiteName { get; set; }

    public RoomDTO(Room room)
    {
        Name = room.Name;
        Lat = room.Lat;
        Lon = room.Lon;
        Alt = room.Alt;
        Level = room.Level;
        SiteName = room.Site.Name;
    }
}