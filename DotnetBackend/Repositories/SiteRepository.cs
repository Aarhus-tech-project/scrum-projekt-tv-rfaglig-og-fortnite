using DotnetBackend.Data;
using DotnetBackend.Models;
using DotnetBackend.Models.DTOs;
using DotnetBackend.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace DotnetBackend.Repositories;

public class SiteRepository(MySQLContext context)
{
    public async Task<List<AddSiteDTO>> GetUserSites(string Email)
    {
        return await context.UserSites
            .Where(us => us.User.Email == Email)
            .Select(us => us.Site)
            .Select(site => new AddSiteDTO(site)
            {
                RoomCount = context.Rooms.Count(r => r.SiteID == site.ID)
            })
            .ToListAsync();
    }

 public async Task AddSiteAsync(Site site)
    {
        context.Sites.Add(site);
        int rowsAffected = await context.SaveChangesAsync();

        if (rowsAffected <= 0)
            throw new Exception("Failed to add classroom");
    }   

    public async Task UpdateSiteAsync(UpdateSiteDTO updateSite)
    {
        var currentSite = await context.Sites.FindAsync(updateSite.ID);
        if (currentSite == null)
            throw new KeyNotFoundException("Site not found");

        currentSite.UpdateSite(updateSite);

        int rowsAffected = await context.SaveChangesAsync();
        if (rowsAffected <= 0)
            throw new Exception("Failed to update site");
    }

    
    public async Task AddUserToSiteAsync(string Email, Site site, UserRole Role)
    {
        var user = await context.Users.FirstOrDefaultAsync(u => u.Email == Email);
        
        if (user == null) {throw new Exception("User not found");}

        UserSite newSite = new UserSite(user.ID, site.ID, Role);
        newSite.Site = site;
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

    public async Task DeleteSiteAsync(string Email, Guid guid)
    {
        Site site = await context.Sites.FirstOrDefaultAsync(site => site.ID == guid);


        if (site == null)
            throw new Exception("Site not found");
            
        var rooms = await context.Rooms.Where(r => r.SiteID == guid).ToListAsync();
        var userSites = await context.UserSites.Where(u => u.SiteID == guid).ToListAsync();
        
        context.Rooms.RemoveRange(rooms);

        context.UserSites.RemoveRange(userSites);

        context.Sites.Remove(site);

        int rowsAffected = await context.SaveChangesAsync();

        if (rowsAffected <= 0)
            throw new Exception("Failed to delete site");
    }
}