using DotnetBackend.Models.Entities;

namespace DotnetBackend.Models.DTOs;

public class SiteDTO(Site site)
{
    public string Name { get; set; } = site.Name;

    public bool IsPublic { get; set; } = site.IsPublic;
}