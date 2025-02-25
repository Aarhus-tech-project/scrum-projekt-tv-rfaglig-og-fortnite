using DotnetBackend.Models.Entities;
using Microsoft.AspNetCore.Authorization.Infrastructure;

namespace DotnetBackend.Models.DTOs;
public class EditSiteDTO
{
    public Guid ID { get; set; }
    public string Name { get; set; } = string.Empty;
    public double Lat { get; set; }
    public double Lon { get; set; }
    public double Alt { get; set; }
    public string Address { get; set; } = string.Empty;
    public bool IsPrivate { get; set; } = false;

    public List<EditRoomDTO> Rooms { get; set; } = new();
    public List<AddEditUserSiteDTO> Users { get; set; } = new();

    public EditSiteDTO(Site site)
    {
        ID = site.ID;
        Name = site.Name;
        Lat = site.Lat;
        Lon = site.Lon;
        Alt = site.Alt;
        Address = site.Address;
        IsPrivate = site.IsPrivate;
    }
}
