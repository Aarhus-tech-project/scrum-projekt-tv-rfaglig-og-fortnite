using DotnetBackend.Data;
using DotnetBackend.Models;
using DotnetBackend.Models.DTOs;
using DotnetBackend.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace DotnetBackend.Repositories;

public class UserRepository(MySQLContext context)
{
    public async Task<bool> UserExists(string email)
    {
        return await context.Users.FirstOrDefaultAsync(u => u.Email == email) != null;
    }

    public async Task<User> GetUserFromEmail(string email)
    {
        return await context.Users.FirstOrDefaultAsync(u => u.Email == email) ?? throw (new KeyNotFoundException());
    }

    public async Task<User> RegisterUser(RegisterUserDTO registerUser)
    {
        User user = new(registerUser);
        await context.Users.AddAsync(user);
        await context.SaveChangesAsync();
        return user;
    }

    public async Task<List<AddEditUserSiteDTO>> GetAddEditUserSiteFromSite(Guid siteID)
    {
        return await context.UserSites.Where(us => us.SiteID == siteID).Select(us => new AddEditUserSiteDTO()
        {
            Email = context.Users.FirstOrDefault(u => u.ID == us.UserID)!.Email,
            Role = us.Role 
        }).ToListAsync();
    }

    public void AddUserSiteForSiteAsync(Guid siteID, List<AddEditUserSiteDTO> users)
    {
        context.UserSites.AddRange(users.Select(ud => new UserSite(
            siteID,
            context.Users.FirstOrDefault(u => u.Email == ud.Email)!.ID,
            ud.Role
        ){
            Site = context.Sites.FirstOrDefault(s => s.ID == siteID)!,
            User = context.Users.FirstOrDefault(u => u.Email == ud.Email)!
        }));
    }

    public void EditUserSiteForSiteAsync(Guid siteID, List<AddEditUserSiteDTO> users)
    {
        context.UserSites.RemoveRange(context.UserSites.Where(us => us.SiteID == siteID));

        context.UserSites.AddRange(users.Select(ud => new UserSite(
            siteID,
            context.Users.FirstOrDefault(u => u.Email == ud.Email)!.ID,
            ud.Role
        ){
            Site = context.Sites.FirstOrDefault(s => s.ID == siteID)!,
            User = context.Users.FirstOrDefault(u => u.Email == ud.Email)!
        }));
    }

    public async Task DeleteUser(Guid guid)
    {
        User user = await context.Users.FirstOrDefaultAsync(user => user.ID == guid) ?? throw new Exception("User not found");
        var userSites = await context.UserSites.Where(u => u.UserID == guid).ToListAsync();
        
        context.UserSites.RemoveRange(userSites);

        context.Users.Remove(user);

        int rowsAffected = await context.SaveChangesAsync();

        if (rowsAffected <= 0)
            throw new Exception("Failed to delete User");
    }
}