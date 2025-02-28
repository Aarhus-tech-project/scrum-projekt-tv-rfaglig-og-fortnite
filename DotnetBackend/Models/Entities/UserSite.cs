using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DotnetBackend.Models.Entities;

public class UserSite 
{
    [ForeignKey("Site")]
    public Guid SiteID { get; set; }
    public Site Site { get; set; }

    [ForeignKey("User")]
    public Guid UserID { get; set; }
    public User User { get; set; }

    [Required]
    public UserRole Role {get; set;}

    public UserSite(Guid userID, Guid siteID, UserRole role)
    {
        UserID = userID;
        SiteID = siteID;
        Role = role;
    }
    
    public UserSite(){}
}

public enum UserRole
{
    Normal,
    Admin
}