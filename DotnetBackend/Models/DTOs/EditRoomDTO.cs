using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;

public class EditRoomDTO
{
    public Guid ID { get; set; }
    public string Name { get; set; } = string.Empty;
    public double Lat { get; set; } = 0.0;
    public double Lon { get; set; } = 0.0;
    public double Alt { get; set; } = 0.0;
    public int Level { get; set; } = 0;

    public EditRoomDTO() { }

    public EditRoomDTO(Room room)
    {
        ID = room.ID;
        Name = room.Name;
        Lat = room.Lat;
        Lon = room.Lon;
        Alt = room.Alt;
        Level = room.Level;
    }
}
