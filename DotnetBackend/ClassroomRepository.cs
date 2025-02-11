using DotNetBackend.Models;
using Microsoft.EntityFrameworkCore;

public class ClassroomRepository
{
    private readonly MySQLContext context;

    public ClassroomRepository(MySQLContext context)
    {
        this.context = context;
    }

    public async Task<List<Room>> GetAllRowsAsync()
    {
        return await context.Rooms.ToListAsync();
    }

    public async Task<int> AddClassroomAsync(Room room)
    {
        context.Rooms.Add(room);
        await context.SaveChangesAsync();
        return room.ID;
        
    }

    public async Task<List<Room>> SearchClassroomsAsync(string keyword)
    {
        //var room = await context.Rooms.FirstOrDefaultAsync();
        //if (room == null) return null;

        //return room;

        return await context.Rooms.Where(r => EF.Functions.Like(r.Name, $"%{keyword}%")).ToListAsync();


    }
}

