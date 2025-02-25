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


    public async Task<User> DeleteUserByEmail(string email)
    {
        var user = await context.Users.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null)
        {
            return null;
        }

        context.Users.Remove(user);
        await context.SaveChangesAsync();
        return user;
    }
}