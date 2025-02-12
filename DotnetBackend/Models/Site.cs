using System.ComponentModel.DataAnnotations;

namespace DotNetBackend.Models;

public class Site
{
    [Key]
    public int ID {get; set;}

    [Required]
    [StringLength(128)]
    public string Name{get; set;}

    public List<Room> Rooms {get; set;} = new List<Room>();

    public bool IsPublic {get; set;} = false;

}