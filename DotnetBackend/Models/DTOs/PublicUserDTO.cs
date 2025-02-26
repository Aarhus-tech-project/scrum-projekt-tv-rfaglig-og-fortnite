using DotnetBackend.Models.Entities;

public class PublicUserDTO
{
    public Guid ID { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    public DateTime CreatedAt { get; set; }

    public PublicUserDTO () {}

    public PublicUserDTO (User user)
    {
        ID = user.ID;
        Name = user.Name;
        Email = user.Email;
        CreatedAt = user.CreatedAt;
    }
}