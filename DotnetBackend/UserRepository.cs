using DotNetBackend.Models;
using Microsoft.EntityFrameworkCore;

public class UserRepository(MySQLContext context, ApiKeyService apiKeyService)
{
    private readonly MySQLContext context = context;
    private readonly ApiKeyService apiKeyService = apiKeyService;

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