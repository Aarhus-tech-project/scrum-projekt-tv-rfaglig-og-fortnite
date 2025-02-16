using System.ComponentModel.DataAnnotations;
using DotnetBackend.Models.DTOs;

namespace DotnetBackend.Models.Entities;

public class Site
{
    [Key]
    public int ID { get; set; }

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

    public  Site(){}

    public Site(SiteDTO siteDTO)
    {
        Name = siteDTO.Name;
        Lat = siteDTO.Lat;
        Lon = siteDTO.Lon;
        Alt = siteDTO.Alt;
        Adresse = siteDTO.Adresse;
        IsPublic = siteDTO.IsPublic;
    }
}