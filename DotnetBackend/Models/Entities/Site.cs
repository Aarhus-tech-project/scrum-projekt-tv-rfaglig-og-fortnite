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

    public Site(AddSiteDTO addSiteDTO)
    {
        ID = Guid.NewGuid();
        Name = addSiteDTO.Name;
        Lat = addSiteDTO.Lat;
        Lon = addSiteDTO.Lon;
        Alt = addSiteDTO.Alt;
        Adresse = addSiteDTO.Address;
        IsPublic = addSiteDTO.IsPublic;
    }

    /*
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


    public Site(ShowSiteDTO showSiteDTO)
    {
        ID = showSiteDTO.ID;
        Name = showSiteDTO.Name;
        Lat = showSiteDTO.Lat;
        Lon = showSiteDTO.Lon;
        Alt = showSiteDTO.Alt;
        Adresse = showSiteDTO.Adresse;
        IsPublic = showSiteDTO.IsPublic;
        RoomCount = showSiteDTO.RoomCount;
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
    } */
}