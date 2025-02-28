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
    public string Address { get; set; }

    public bool IsPrivate { get; set; } = false;   

    public  Site(){}

    public Site(AddSiteDTO addSiteDTO)
    {
        ID = Guid.NewGuid();
        Name = addSiteDTO.Name;
        Lat = addSiteDTO.Lat;
        Lon = addSiteDTO.Lon;
        Alt = addSiteDTO.Alt;
        Address = addSiteDTO.Address;
        IsPrivate = addSiteDTO.IsPrivate;
    }

    public void Update(EditSiteDTO updateSite)
    {

        Name = updateSite.Name;
        Lat = updateSite.Lat;
        Lon = updateSite.Lon;
        Alt = updateSite.Alt;
        Address = updateSite.Address;
        IsPrivate = updateSite.IsPrivate;
    }
}