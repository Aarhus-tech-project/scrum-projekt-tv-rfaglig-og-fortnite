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
        try
        {
            context.Rooms.Add(room);
            await context.SaveChangesAsync();
            return room.ID;
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
            return -1;
        }
    }

    public async Task<Room> GetRowAsync()
    {
        var room = await context.Rooms.FirstOrDefaultAsync();
        if (room == null) return null;

        return room;

    }
}

