using DotnetBackend.Data;
using DotnetBackend.Models;
using DotnetBackend.Models.DTOs;
using DotnetBackend.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace DotnetBackend.Repositories;

public class RoomRepository(MySQLContext context)
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

    public async Task EditRoomsForSiteAsync(Guid siteID, List<EditRoomDTO> rooms)
    {
        var existingRoomIDs = await context.Rooms
            .Where(r => r.SiteID == siteID)
            .Select(r => r.ID)
            .ToListAsync();

        var newRoomIDs = rooms.Select(r => r.ID).ToList();

        var roomsToDelete = existingRoomIDs.Except(newRoomIDs).ToList();
        if(roomsToDelete.Count != 0)
        {
            context.Rooms.RemoveRange(context.Rooms.Where(r => roomsToDelete.Contains(r.ID)));
        }

        foreach (var room in rooms)
        {
            var existingRoom = await context.Rooms.FirstOrDefaultAsync(r => r.ID == room.ID);
            if (existingRoom == null)
            {
                context.Rooms.Add(new Room(room, siteID));   
            }
            else
            {
                existingRoom.Update(room);
            }
        }

        await context.SaveChangesAsync();
    }

    public async Task<List<EditRoomDTO>> GetEditRoomsFromSiteAsync(Guid siteID)
    {
        return await context.Rooms.Where(r => r.SiteID == siteID).Select(r => new EditRoomDTO(r)).ToListAsync();
    }

    public async Task<List<PublicRoomDTO>> SearchClassroomsAsync(string keyword, int limit = 10)
    {
        return await context.Rooms.Where(r => EF.Functions.Like(r.Name.ToLower(), $"%{keyword.ToLower()}%"))
            .Include(r => r.Site)
            .Take(limit)
            .Select(r => new PublicRoomDTO(r)
            {
                SiteName = r.Site.Name
            })
            .ToListAsync();
    }

    public async Task<List<PublicRoomDTO>> SearchNearbyRoomsAsync(double lat, double lon, double alt, string keyword, int limit = 10)
    {
        return await context.Rooms.FromSqlInterpolated($"SELECT *, (6371 * ACOS(COS(RADIANS({lat})) * COS(RADIANS(Lat)) * COS(RADIANS(Lon) - RADIANS({lon})) + SIN(RADIANS({lat})) * SIN(RADIANS(Lat)))) AS Distance FROM rooms WHERE Name LIKE CONCAT('%', {keyword}, '%') ORDER BY Distance ASC LIMIT {limit}")
        .Include(r => r.Site)
        .Select(r => new PublicRoomDTO(r) 
        {
            SiteName = r.Site.Name
        })
        .ToListAsync();
    }
}