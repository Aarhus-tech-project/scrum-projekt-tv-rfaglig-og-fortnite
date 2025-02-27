using System.Net.Http.Headers;
using DotnetBackend.Models;
using DotnetBackend.Models.DTOs;
using DotnetBackend.Models.Entities;
using DotnetBackend.Repositories;
using DotnetBackend.Services;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

namespace DotnetBackend.Controllers;

[Route("api")]
public class RoomController(RoomRepository classroomRepository, ApiKeyService apiKeyService) : Controller
{
    [HttpGet("SearchClassrooms")]
    public async Task<IActionResult> SearchClassrooms(string keyword = "", int limit = 10)
    {
        try
        {           
            var classrooms = await classroomRepository.SearchClassroomsAsync(keyword, limit);

            if (classrooms == null)
                return NotFound("No matching classrooms found");
            
            return Ok(classrooms);
        }
        catch (Exception)
        {
            return StatusCode(500);
        }
    }

    [HttpGet("SearchNearbyClassrooms")]
    public async Task<IActionResult> SearchNearbyClassrooms([FromHeader(Name = "X-Api-Key")] string apiKey, double lat, double lon, double alt, string keyword = "", int limit = 10)
    {
        try
        {
            if (!apiKeyService.ValidateApiKey(apiKey, out var user)) 
                return Unauthorized("Unauthorized");
            var classrooms = await classroomRepository.SearchNearbyRoomsAsync(apiKey, user.ID, lat, lon, alt, keyword, limit);

            if (classrooms == null)
                return NotFound("No matching classrooms found");

            return Ok(classrooms);
        }
        catch (Exception e)
        {
            return StatusCode(500);
        }
    }

    /*
    [HttpPost("AddClassrooms")]
    public async Task<IActionResult> AddClassroom([FromHeader(Name = "X-Api-Key")] string apiKey, [FromBody] AddRoomDTO addRoomDTO, Guid siteID)
    {
         if (!apiKeyService.ValidateApiKey(apiKey, out var clientName)) 
            return Unauthorized("Unauthorized");

        try
        {
            await classroomRepository.AddClassroomAsync(new Room(addRoomDTO, siteID));

            return Ok();
        }
        catch (Exception)
        {
            return StatusCode(500);
        }
    }
    */
}