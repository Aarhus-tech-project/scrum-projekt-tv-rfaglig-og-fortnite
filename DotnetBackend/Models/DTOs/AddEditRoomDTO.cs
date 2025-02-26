using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;

public class AddEditRoomDTO
{
    public string Name { get; set; } = string.Empty;
    public double Lat { get; set; } = 0.0;
    public double Lon { get; set; } = 0.0;
    public double Alt { get; set; } = 0.0;
    public int Level { get; set; } = 0;

    public AddEditRoomDTO() { }

    public AddEditRoomDTO(Room room)
    {
        Name = room.Name;
        Lat = room.Lat;
        Lon = room.Lon;
        Alt = room.Alt;
        Level = room.Level;
    }
}