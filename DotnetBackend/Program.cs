using MongoDB.Driver;
using MySql.Data.MySqlClient;
using System;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
try
        {
            var connectionString = builder.Configuration.GetConnectionString("MySQL");

            using (var connection = new MySqlConnection(connectionString))
            {
                connection.Open();
                Console.WriteLine("Connected to MySQL server successfully!");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to connect to MySQL server: {ex.Message}");
        }
        
app.Run();




