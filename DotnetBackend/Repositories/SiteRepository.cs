using DotnetBackend.Data;
using DotnetBackend.Models;
using DotnetBackend.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace DotnetBackend.Repositories;

public class SiteRepository(MySQLContext context)
{
    public async Task<List<Site>> GetUserSites(string Email)
    {
        return await context.UserSites
            .Where(us => us.User.Email == Email)
            .Include(us => us.Site)
            .Select(us => us.Site)
            .ToListAsync();
    }

    public async Task AddSiteAsync(string Email, Site site)
    {
        
        context.Sites.Add(site);
        int rowsAffected = await context.SaveChangesAsync();

        if (rowsAffected <= 0)
            throw new Exception("Failed to add classroom");
    }
    
    public async Task AddUserToSiteAsync(string Email, Site site, UserRole Role)
    {
        var user = await context.Users.FirstOrDefaultAsync(u => u.Email == Email);
        
        if (user == null) {throw new Exception("User not found");}

        UserSite newSite = new UserSite(user.ID, site.ID, Role);
        context.UserSites.Add(newSite);

        int rowsAffected = await context.SaveChangesAsync();
        if (rowsAffected <= 0)
            throw new Exception("Failed to add classroom");
    }

    public async Task<List<Site>> FindNearestSite(string userEmail, double lat, double lon, double alt, string keyword, int limit = 10)
    {
        return await context.Sites.FromSqlInterpolated
        ($@"SELECT s.*, 
        (6371 * ACOS(COS(RADIANS({lat})) * COS(RADIANS(s.Lat)) *
        COS(RADIANS(s.Lon) - RADIANS({lon})) + SIN(RADIANS({lat})) * 
        SIN(RADIANS(s.Lat)))) AS Distance 
        FROM Sites s
        WHERE s.Id NOT IN (
        SELECT us.SiteID FROM UserSites us
        JOIN Users u ON us.UserID = u.Id
        WHERE u.Email = {userEmail}
        )
        AND s.Name LIKE CONCAT('%', {keyword}, '%')
        ORDER BY Distance ASC 
        LIMIT {limit}")
        .ToListAsync();
    }

}