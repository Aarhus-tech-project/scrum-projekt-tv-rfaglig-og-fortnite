using DotNetBackend.Models;
using Microsoft.EntityFrameworkCore;

public class UserRepository
{
    private readonly MySQLContext context;
    private readonly ApiKeyService apiKeyService;

    public UserRepository(MySQLContext context, ApiKeyService apiKeyService)
    {
        this.context = context;
        this.apiKeyService = apiKeyService;
    }

    public async Task<bool> UserExists(string email)
    {
        return await context.Users.FirstOrDefaultAsync(u => u.Email == email) != null;
    }

    public async Task<User> GetUserFromEmail(string email)
    {
        return await context.Users.FirstOrDefaultAsync(u => u.Email == email) ?? throw(new KeyNotFoundException());
    }

    public async Task<User> RegisterUser(RegisterUserDTO registerUser)
    {
        User user = new(registerUser);
        await context.Users.AddAsync(user);
        await context.SaveChangesAsync();
        return user;
    }
}