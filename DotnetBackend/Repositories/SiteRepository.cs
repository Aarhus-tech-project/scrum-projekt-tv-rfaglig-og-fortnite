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
}