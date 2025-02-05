using System.ComponentModel.DataAnnotations;

namespace DotNetBackend.Models
{

    public class Room
    {
        [Key] public int Id {get; set;}
        required public string Name {get; set;}
        required public double Lat {get; set;}
        required public double Lon {get; set;}
        required public double Alt {get; set;}
        required public int Level {get; set;}
        required public string Site {get; set;}
    }
}