using System.ComponentModel.DataAnnotations;

namespace DotnetBackend.Models.Entities;

public class Site
{
    [Key]
    public int ID { get; set; }

    [Required]
    [StringLength(128)]
    public string Name { get; set; }

    public List<Room> Rooms { get; set; } = [];

    public bool IsPublic { get; set; } = false;
}