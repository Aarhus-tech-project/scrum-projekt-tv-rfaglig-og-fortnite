using MySql.Data.MySqlClient;
using System;

public class DatabaseHelper
{
    private readonly MySqlConnection _connection;

    public DatabaseHelper(MySqlConnection connection)
    {
        _connection = connection;
    }

    public object GetVariable(string table, string column, string condition = "1=1")
    {
        object result = null;
        string query = $"SELECT {column} FROM {table} WHERE {condition} LIMIT 1;";

        using (MySqlCommand command = new MySqlCommand(query, _connection))
        {
            try
            {
                if (_connection.State != System.Data.ConnectionState.Open)
                    _connection.Open();

                result = command.ExecuteScalar();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }

        return result;
    }

    

}