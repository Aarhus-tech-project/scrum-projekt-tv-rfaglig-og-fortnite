using DotnetBackend.Models.Entities;

namespace DotnetBackend.Models.DTOs;

public class UpdateSiteDTO
{

    public Guid ID {get; set;}
    public string Name { get; set; }

    public double Lat { get; set; }

    public double Lon { get; set; }

    public double Alt { get; set; }

    public string Adresse { get; set; }

    public bool IsPublic { get; set; }

    public int RoomCount { get; set; }
}