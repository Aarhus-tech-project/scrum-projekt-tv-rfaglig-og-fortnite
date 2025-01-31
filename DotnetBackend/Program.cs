using MySql.Data.MySqlClient;
using System;

var builder = WebApplication.CreateBuilder(args);

// Get connection string from appsettings.json
var connectionString = builder.Configuration.GetConnectionString("MySQL");

// Register MySqlConnection as a service
builder.Services.AddTransient<MySqlConnection>(_ => new MySqlConnection(connectionString));

// Add CORS policy
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins",
        builder =>
        {
            builder.AllowAnyOrigin()
                   .AllowAnyMethod()
                   .AllowAnyHeader();
        });
});

var app = builder.Build();

app.UseHttpsRedirection();

MySqlConnection connection = new MySqlConnection(connectionString);

connection.Open();

DatabaseHelper databasehelper = new DatabaseHelper(connection);

var a = databasehelper.GetVariable("rooms", "name");

app.Run();
