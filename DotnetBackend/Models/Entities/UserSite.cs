using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DotNetBackend.Models;

public class UserSite
{
    [ForeignKey("Site")]
    public int SiteID {get; set;}
    public Site Site {get; set;}

    [ForeignKey("User")]
    public int UserID{get; set;}
    public User User {get; set;}

    [Required]
    public UserRole Role {get; set;}


}

public enum UserRole
{
    Normal,
    Admin
}