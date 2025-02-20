using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DotnetBackend.Models.DTOs;

namespace DotnetBackend.Models.Entities;

public class Site
{
    [Key]
    public Guid ID { get; set; }

    [Required]
    [StringLength(128)]
    public string Name { get; set; }

    [Required]
    public double Lat { get; set; }

    [Required]
    public double Lon { get; set; }

    [Required]
    public double Alt { get; set; }

    [Required]
    public string Adresse { get; set; }

    public bool IsPublic { get; set; } = false;   

    public int RoomCount {get; set;}

    public  Site(){}

    public Site(AddSiteDTO siteDTO)
    {
        ID = Guid.NewGuid();
        Name = siteDTO.Name;
        Lat = siteDTO.Lat;
        Lon = siteDTO.Lon;
        Alt = siteDTO.Alt;
        Adresse = siteDTO.Adresse;
        IsPublic = siteDTO.IsPublic;
        RoomCount = siteDTO.RoomCount;
    }

    public Site(UpdateSiteDTO updateSiteDTO)
    {
        ID = updateSiteDTO.ID;
        Name = updateSiteDTO.Name;
        Lat = updateSiteDTO.Lat;
        Lon = updateSiteDTO.Lon;
        Alt = updateSiteDTO.Alt;
        Adresse = updateSiteDTO.Adresse;
        IsPublic = updateSiteDTO.IsPublic;
        RoomCount = updateSiteDTO.RoomCount;
    }

    public void UpdateSite(UpdateSiteDTO updateSite)
    {

        Name = updateSite.Name;
        Lat = updateSite.Lat;
        Lon = updateSite.Lon;
        Alt = updateSite.Alt;
        Adresse = updateSite.Adresse;
        IsPublic = updateSite.IsPublic;
        RoomCount = updateSite.RoomCount;   
    }
}