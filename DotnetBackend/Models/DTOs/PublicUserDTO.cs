using DotnetBackend.Models.Entities;

public class PublicUserDTO
{
    public string Name { get; set; }
    public string Email { get; set; }
    public DateTime CreatedAt { get; set; }

    public PublicUserDTO () {}

    public PublicUserDTO (User user)
    {
        Name = user.Name;
        Email = user.Email;
        CreatedAt = user.CreatedAt;
    }
}