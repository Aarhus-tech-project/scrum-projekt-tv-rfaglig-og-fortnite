using DotNetBackend.Models;
using Microsoft.EntityFrameworkCore;

public class SiteRepository(MySQLContext context)
{

    
    public async Task<List<Site>> GetUserSites(string Email)
    {
        return await context.UserSites
            .Where(us => us.User.Email == Email)
            .Include(us => us.Site) // Ensure Site is loaded
            .Select(us => us.Site)  // Extract only Site objects
            .ToListAsync();
    }
}