using System.Net.Http.Headers;
using DotNetBackend.Models;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

[Route("api")]
public class ClassroomController : Controller
{
    private readonly ClassroomRepository classroomRepository;

    public ClassroomController(ClassroomRepository classroomRepository)
    {
        this.classroomRepository = classroomRepository;
    }

    [HttpGet("Classrooms")]
    public async Task<IActionResult> GetClassrooms()
    {
        var navn =  await classroomRepository.GetAllRowsAsync();
        return Ok(navn);

    }

    [HttpPost("Classrooms")]
    public async Task<IActionResult> AddClassroom([FromBody] AddRoomDTO addRoomDTO)
    {
        var result = await classroomRepository.AddClassroomAsync(new Room(addRoomDTO));

        return Ok();
    }

    [HttpGet("SearchClassrooms")]
    public async Task<IActionResult> GetClassroom(string keyword = "", int limit = 10)
    {
        
        //var row = await classroomRepository.GetRowAsync(keyword);

        //if (row == null)
          //  return NotFound("No data found");

        //return Ok(row);

        var row = await classroomRepository.SearchClassroomsAsync(keyword);

        var hans = new List<AddRoomDTO>();

        foreach (var currentItem in hans) 
        {
            hans.Add(currentItem);
            
        }

        if (row == null)
            return NotFound("No matching classroom found");

        return Ok(row);
    }
}