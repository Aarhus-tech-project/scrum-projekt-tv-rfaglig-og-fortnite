using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using DotNetBackend.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

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

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// Use specific CORS policy
app.UseCors("AllowAllOrigins");

// MongoDB connection
var mongoClient = new MongoClient("mongodb+srv://Peter:scMttGq4JMvhJWHb@myweb.7styx.mongodb.net/my_test_database?retryWrites=true&w=majority");
var database = mongoClient.GetDatabase("my_test_database");
var collection = database.GetCollection<BsonDocument>("classrooms");

app.MapGet("/classrooms", async () =>
{
    var classrooms = await collection.Find(new BsonDocument()).ToListAsync();
    var classroomList = new List<Classroom>();

    foreach (var classroom in classrooms)
    {
        classroom.TryGetValue("_id", out var id);
        classroom.TryGetValue("ClassroomName", out var ClassroomName);
        classroom.TryGetValue("Level", out var level);
        classroom.TryGetValue("Latitude", out var latitude);
        classroom.TryGetValue("Longitude", out var longitude);

        classroomList.Add(new Classroom
        {

            ClassroomName = ClassroomName?.ToString() ?? string.Empty,
            Level = level?.ToInt32() ?? 0,
            Latitude = latitude?.ToDouble() ?? 0.0,
            Longitude = longitude?.ToDouble() ?? 0.0
        });
    }

    return Results.Ok(classroomList);
});

app.Run();