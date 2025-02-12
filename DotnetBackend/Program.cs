using MySql.Data.MySqlClient;
using Microsoft.OpenApi.Models;
using System;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

string connectionString = builder.Configuration.GetConnectionString("MySQL") ?? throw(new KeyNotFoundException());

builder.Services.AddDbContext<MySQLContext>(options => 
    options.UseMySql(
        connectionString,
        ServerVersion.AutoDetect(connectionString)
    ));
builder.Services.AddSingleton<ApiKeyService>();
builder.Services.AddScoped<ClassroomRepository>();
builder.Services.AddScoped<UserRepository>();
builder.Services.AddScoped<SiteRepository>();

// Register MySqlConnection as a service
builder.Services.AddControllers(options =>
{
    options.Filters.Add<ApiKeyAuthorizationFilter>();
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Classroom Finder",
        Version = "v1",
        Description = "API for Classroom Finder App",
    });
});

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

app.UseAuthorization();
app.MapControllers();

app.UseHttpsRedirection();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint("/swagger/v1/swagger.json", "Classroom Finder API");
        options.RoutePrefix = string.Empty; // This makes Swagger available at the root URL
    });
}

app.Run();

