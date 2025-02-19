using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;

public class SiteDTO
{
    public string Name { get; set; }

    public double Lat { get; set; }

    public double Lon { get; set; }

    public double Alt { get; set; }

    public string Adresse { get; set; }

    public bool IsPublic { get; set; }

    public int RoomCount { get; set; }

    public SiteDTO(Site site)
    {
        Name = site.Name;
        Lat = site.Lat;
        Lon = site.Lon;
        Alt = site.Alt;
        Adresse = site.Adresse;
        IsPublic = site.IsPublic;
    }

    public SiteDTO() { }
}