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

}