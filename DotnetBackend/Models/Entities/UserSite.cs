using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DotnetBackend.Models.Entities;

public class UserSite 
{
    [ForeignKey("Site")]
    public int SiteID { get; set; }
    public Site Site { get; set; }

    [ForeignKey("User")]
    public int UserID { get; set; }
    public User User { get; set; }

    [Required]
    public UserRole Role {get; set;}

    public UserSite(int userID, int siteID, UserRole role)
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