

using DotnetBackend.Models.Entities;

public class PublicSiteDTO
{
    public Guid ID { get; set; }
    public string Name { get; set; }
    public string Address { get; set; }
    public int RoomCount { get; set; }

    public PublicSiteDTO(Site site)
    {
        ID = site.ID;
        Name = site.Name;
        Address = site.Address;   
    }
}