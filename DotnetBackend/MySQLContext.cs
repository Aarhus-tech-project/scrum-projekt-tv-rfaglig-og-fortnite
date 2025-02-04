using DotNetBackend.Models;
using Microsoft.AspNetCore.Http.HttpResults;
using MySql.Data.MySqlClient;
using System;

public class MySqlContext
{
    private readonly MySqlConnection connection;

    public MySqlContext(string connectionString)
    {
        connection = new MySqlConnection(connectionString);
    }

    public object GetVariable(string table, string column, string condition = "1=1")
    {
        object result = null;
        string query = $"SELECT {column} FROM {table} WHERE {condition} LIMIT 1;";

        using (MySqlCommand command = new MySqlCommand(query, connection))
        {
            try
            {
                if (connection.State != System.Data.ConnectionState.Open)
                    connection.Open();

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
        var rows = new List<Dictionary<string, object>>();
    
            string query = $"SELECT * FROM {tableName}"; 
            using (var cmd = new MySqlCommand(query, connection))
            {
                if (connection.State != System.Data.ConnectionState.Open)
                    connection.Open();
                using (var reader = await cmd.ExecuteReaderAsync())
                {
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
            }
        return rows;
    }

    public async Task<object> AddClassroomAsync(Room room)
    {
        object result = null;
        string query = @"
        INSERT INTO rooms (name, lat, lon, alt, level, site) 
        VALUES (@name, @lat, @lon, @alt, @level, @site)";

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

                if (connection.State != System.Data.ConnectionState.Open)
                    connection.Open();

                result = await command.ExecuteScalarAsync();
                
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }

        return result;
    }
    
    //virker ikke
    public async Task<Dictionary<string, object>?> GetRow(string tableName, int limit)
    {
        string query = $"SELECT * FROM {tableName} LIMIT 1"; 
        
        using (var cmd = new MySqlCommand(query, connection))
        {
            if (connection.State != System.Data.ConnectionState.Open)
                connection.Open();
            using (var reader = await cmd.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync())
                {
                    var row = new Dictionary<string, object>();
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        row[reader.GetName(i)] = reader.GetValue(i);
                    }
                    return row;
                }
            }
        }
        return null;
    }


}