using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DotnetBackend.Models.DTOs;

namespace DotnetBackend.Models.Entities;

public class Room
{
    [Key]
    public Guid ID { get; set; }

    [Required]
    [StringLength(64)]
    public string Name { get; set; }

    [Required]
    public double Lat { get; set; }

    [Required]
    public double Lon { get; set; }

    [Required]
    public double Alt { get; set; }

    [Required]
    public int Level { get; set; }

    [ForeignKey("SiteID")]
    public Guid SiteID { get; set; }
    public Site Site { get; set; }

    public Room(AddRoomDTO addRoomDTO)
    {
        ID = Guid.NewGuid();
        Name = addRoomDTO.Name;
        Lat = addRoomDTO.Lat;
        Lon = addRoomDTO.Lon;
        Alt = addRoomDTO.Alt;
        Level = addRoomDTO.Level;
    }

    public Room(EditRoomDTO editRoomDTO, Guid siteID) 
    {
        ID = editRoomDTO.ID == Guid.Empty ? Guid.NewGuid() : editRoomDTO.ID;
        Name = editRoomDTO.Name;
        Lat = editRoomDTO.Lat;
        Lon = editRoomDTO.Lon;
        Alt = editRoomDTO.Alt;
        Level = editRoomDTO.Level;
        SiteID = siteID;
    }

    public Room() {}

    public void Update(EditRoomDTO editRoomDTO)
    {
        Name = editRoomDTO.Name;
        Lat = editRoomDTO.Lat;
        Lon = editRoomDTO.Lon;
        Alt = editRoomDTO.Alt;
        Level = editRoomDTO.Level;
    }
}
