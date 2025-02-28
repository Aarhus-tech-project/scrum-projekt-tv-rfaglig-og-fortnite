using DotnetBackend.Models.Entities;
using Humanizer;

public class PublicRoomDTO
{
    public Guid ID { get; set; }

    public string Name { get; set; }

    public double Lat { get; set; }

    public double Lon { get; set; }

    public double Alt { get; set; }

    public int Level { get; set; }

    public string SiteName { get; set; }

    public PublicRoomDTO (Room room) 
    {
        ID = room.ID;
        Name = room.Name;
        Lat = room.Lat;
        Lon = room.Lon;
        Alt = room.Alt;
        Level = room.Level;
    }
}