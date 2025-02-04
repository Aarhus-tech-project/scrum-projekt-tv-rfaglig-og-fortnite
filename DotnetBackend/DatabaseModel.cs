using System.ComponentModel.DataAnnotations;

public class RoomsDataModel

{
    [Key] public int id { get; set; }
    required public string name { get; set; }
    required public double lat { get; set; }
    required public double lon { get; set; }
    required public double alt { get; set; }
    required public int level { get; set; }
    required public string site { get; set; }
}