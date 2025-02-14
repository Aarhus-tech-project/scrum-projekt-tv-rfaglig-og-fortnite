using System.Net.Http.Headers;
using DotnetBackend.Models;
using DotnetBackend.Models.DTOs;
using DotnetBackend.Models.Entities;
using DotnetBackend.Repositories;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

namespace DotnetBackend.Controllers;

[Route("api")]
public class ClassroomController(ClassroomRepository classroomRepository) : Controller
{
    [HttpPost("AddClassrooms")]
    public async Task<IActionResult> AddClassroom([FromBody] RoomDTO room)
    {
        try
        {            
            await classroomRepository.AddClassroomAsync(new Room(room));
            return Ok();
        }
        catch (Exception)
        {
            return StatusCode(500);
        }
    }

    [HttpGet("SearchClassrooms")]
    public async Task<IActionResult> SearchClassrooms(string keyword = "", int limit = 10)
    {
        try
        {           
            var classrooms = await classroomRepository.SearchClassroomsAsync(keyword, limit);

            if (classrooms == null)
                return NotFound("No matching classrooms found");
            
            return Ok(classrooms.Select(c => new RoomDTO(c)));
        }
        catch (Exception)
        {
            return StatusCode(500);
        }
    }

    [HttpGet("SearchNearbyClassrooms")]
    public async Task<IActionResult> SearchNearbyClassrooms(double lat, double lon, string keyword = "", int limit = 10)
    {
        try
        {
            var classrooms = await classroomRepository.SearchNearbyRoomsAsync(lat, lon, keyword, limit);

            if (classrooms == null)
                return NotFound("No matching classrooms found");

            return Ok(classrooms.Select(c => new RoomDTO(c)));
        }
        catch (Exception)
        {
            return StatusCode(500);
        }
    }
}