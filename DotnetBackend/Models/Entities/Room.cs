using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DotnetBackend.Models.DTOs;

namespace DotnetBackend.Models.Entities;

public class Room
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
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

    public Room() {}

    public Room(RoomDTO roomDTO)
    {
        Name = roomDTO.Name;
        Lat = roomDTO.Lat;
        Lon = roomDTO.Lon;
        Alt = roomDTO.Alt;
        Level = roomDTO.Level;
    }
}
