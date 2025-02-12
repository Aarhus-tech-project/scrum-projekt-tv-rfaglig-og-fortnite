using DotnetBackend.Models.Entities;

namespace DotnetBackend.Models.DTOs;

public class RoomDTO(Room room)
{
    public string Name { get; set; } = room.Name;
    public double Lat { get; set; } = room.Lat;
    public double Lon { get; set; } = room.Lon;
    public double Alt { get; set; } = room.Alt;
    public int Level { get; set; } = room.Level;
}