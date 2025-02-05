using DotNetBackend.Models;
using MySql.Data.MySqlClient;

public class ClassroomRepository
{
    private readonly MySqlContext context;

    public ClassroomRepository(MySqlContext context)
    {
        this.context = context;
    }

    public object GetVariable(string table, string column, string condition = "1=1")
    {
        string query = $"SELECT {column} FROM {table} WHERE {condition} LIMIT 1;";
        object result = null;

        using (MySqlConnection connection = context.GetConnection())
        using (MySqlCommand command = new MySqlCommand(query, connection))
        {
            try
            {
                result = command.ExecuteScalar();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }
        return result;
    }

    public async Task<List<Dictionary<string, object>>> GetAllRowsAsync(string tableName)
    {
        string query = $"SELECT * FROM {tableName}"; 
        var rows = new List<Dictionary<string, object>>();

        using (MySqlConnection connection = context.GetConnection())
        using (var cmd = new MySqlCommand(query, connection))
        {
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var row = new Dictionary<string, object>();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    row[reader.GetName(i)] = reader.GetValue(i);
                }
                rows.Add(row);
            }
        }
        return rows;
    }

    public async Task<object> AddClassroomAsync(Room room)
    {
        string query = @"
        INSERT INTO rooms (name, lat, lon, alt, level, site) 
        VALUES (@name, @lat, @lon, @alt, @level, @site)";
        object result = null;

        using (MySqlConnection connection = context.GetConnection())
        using (MySqlCommand command = new MySqlCommand(query, connection))
        {
            try
            {

                command.Parameters.AddWithValue("@name", room.Name);
                command.Parameters.AddWithValue("@lat", room.Lat);
                command.Parameters.AddWithValue("@lon", room.Lon);
                command.Parameters.AddWithValue("@alt", room.Alt);
                command.Parameters.AddWithValue("@level", room.Level);
                command.Parameters.AddWithValue("@site", room.Site);

                result = await command.ExecuteScalarAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }

        return result;
    }
    
    //Virker Perfekt
    public async Task<Dictionary<string, object>?> GetRow(string tableName, int limit)
    {
        string query = $"SELECT * FROM {tableName} LIMIT 1";

        using MySqlConnection connection = context.GetConnection();
        using var cmd = new MySqlCommand(query, connection);
        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            var row = new Dictionary<string, object>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                row[reader.GetName(i)] = reader.GetValue(i);
            }
            return row;
        }
        return null;
    }
}