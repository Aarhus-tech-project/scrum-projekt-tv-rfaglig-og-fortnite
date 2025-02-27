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

    public void AddRoomsForSiteAsync(Guid siteID, List<AddEditRoomDTO> rooms)
    {
        context.Rooms.AddRange(rooms.Select(r => new Room(r, siteID)));
    }

    public void EditRoomsForSiteAsync(Guid siteID, List<AddEditRoomDTO> rooms)
    {
        context.Rooms.RemoveRange(context.Rooms.Where(r => r.SiteID == siteID));

        context.Rooms.AddRange(rooms.Select(r => new Room(r, siteID)));
    }

    public async Task<List<AddEditRoomDTO>> GetEditRoomsFromSiteAsync(Guid siteID)
    {
        return await context.Rooms.Where(r => r.SiteID == siteID).Select(r => new AddEditRoomDTO(r)).ToListAsync();
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

   public async Task<List<PublicRoomDTO>> SearchNearbyRoomsAsync(string apiKey, Guid userId, double lat, double lon, double alt, string keyword, int limit = 10)
{
   /* return await context.Rooms.FromSqlInterpolated($@"
        SELECT r.*, 
               (6371 * ACOS(COS(RADIANS({lat})) * COS(RADIANS(r.Lat)) 
               * COS(RADIANS(r.Lon) - RADIANS({lon})) + SIN(RADIANS({lat})) 
                * SIN(RADIANS(r.Lat)))) AS Distance 
        FROM rooms r
        JOIN sites s ON r.SiteID = s.ID
        JOIN UserSites us ON us.SiteID = s.ID
        WHERE us.UserID = {BitConverter.ToString(userId.ToByteArray()).Replace("-","")}
        AND r.Name LIKE CONCAT('%', {keyword}, '%')
        ORDER BY Distance ASC
        LIMIT {limit}") 
    .Include(r => r.Site)
    .Select(r => new PublicRoomDTO(r) 
    {
        SiteName = r.Site.Name
    })
    .ToListAsync();*/

    {
        return await context.Rooms
        .FromSqlInterpolated($@"
            SELECT *, 
            (6371 * ACOS(
            COS(RADIANS({lat})) * COS(RADIANS(Lat)) 
            * COS(RADIANS(Lon) - RADIANS({lon})) 
            + SIN(RADIANS({lat})) * SIN(RADIANS(Lat)))) AS Distance 
            FROM rooms 
            WHERE Name LIKE CONCAT('%', {keyword}, '%') 
            ORDER BY Distance ASC 
            LIMIT {limit}")
        .Include(r => r.Site)
        .Select(r => new PublicRoomDTO(r) 
        {
            SiteName = r.Site.Name
        })
        .ToListAsync();

    }

}

}