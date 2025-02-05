using DotNetBackend.Models;
using Microsoft.AspNetCore.Http.HttpResults;
using MySql.Data.MySqlClient;
using System;
using System.Data;

public class MySqlContext : IDisposable
{
    private readonly string connectionString;
    private MySqlConnection connection;

    public MySqlContext(string connectionString)
    {
        this.connectionString = connectionString;
        this.connection = new MySqlConnection(connectionString);
    }

    public MySqlConnection GetConnection()
    {
        if (connection.State == ConnectionState.Closed)
        {
            connection.Open();
        }

        return connection;
    }

    public void Dispose()
    {
        if (connection != null && connection.State != ConnectionState.Closed)
        {
            connection.Close();
        }

        connection?.Dispose();
    }
}