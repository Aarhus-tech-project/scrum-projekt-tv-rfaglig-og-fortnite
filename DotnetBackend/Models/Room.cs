using System.ComponentModel.DataAnnotations;

namespace DotNetBackend.Models
{

    public class Room
    {
        [Key]
        public int ID { get; set; }

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

        [Required]
        [StringLength(128)]
        public string Site { get; set; } 
        
        public Room()
        {
            
        }
        
        public Room(RoomDTO roomDTO)
        {
            Name = roomDTO.Name;
            Lat = roomDTO.Lat;
            Lon = roomDTO.Lon;
            Alt = roomDTO.Alt;
            Level = roomDTO.Level;
            Site = roomDTO.Site;
        }
    }
}