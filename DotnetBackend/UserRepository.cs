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

    public async Task<List<Room>> GetNearbyRoomsAsync(string keyword, double lat, double lon, int limit = 10)
    {
        return await context.Rooms
            .FromSqlInterpolated($"SELECT *, (6371 * ACOS(COS(RADIANS({lat})) * COS(RADIANS(Lat)) * COS(RADIANS(Lon) - RADIANS({lon})) + SIN(RADIANS({lat})) * SIN(RADIANS(Lat)))) AS Distance FROM rooms WHERE Name LIKE CONCAT('%', {keyword}, '%') ORDER BY Distance ASC LIMIT {limit}")
            .ToListAsync();
    }
}