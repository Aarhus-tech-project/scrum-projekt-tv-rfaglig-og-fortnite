using DotnetBackend.Data;
using DotnetBackend.Models;
using DotnetBackend.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace DotnetBackend.Repositories;

public class ClassroomRepository(MySQLContext context)
{
    public async Task<List<Room>> GetAllRowsAsync()
    {
        return await context.Rooms.ToListAsync();
    }

    public async Task AddClassroomAsync(Room room)
    {
        context.Rooms.Add(room);
        int rowsAffected = await context.SaveChangesAsync();

        if (rowsAffected <= 0)
            throw new Exception("Failed to add classroom");
    }

    public async Task<List<Room>> SearchClassroomsAsync(string keyword, int limit = 10)
    {
        return await context.Rooms.Where(r => EF.Functions.Like(r.Name, $"%{keyword}%")).Take(limit).ToListAsync();
    }

    public async Task<List<Room>> SearchNearbyRoomsAsync(double lat, double lon, string keyword, int limit = 10)
    {
        return await context.Rooms.FromSqlInterpolated($"SELECT *, (6371 * ACOS(COS(RADIANS({lat})) * COS(RADIANS(Lat)) * COS(RADIANS(Lon) - RADIANS({lon})) + SIN(RADIANS({lat})) * SIN(RADIANS(Lat)))) AS Distance FROM rooms WHERE Name LIKE CONCAT('%', {keyword}, '%') ORDER BY Distance ASC LIMIT {limit}").ToListAsync();
    }
}