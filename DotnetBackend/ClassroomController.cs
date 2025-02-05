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

        var navn = new List<Dictionary<string, object>>();
        navn = await classroomRepository.GetAllRowsAsync();

        classroomRepository.GetVariable("1", "hans");

        return Ok(navn);

    }

    [HttpPost("Classrooms")]
    public async Task<IActionResult> AddClassroom([FromBody] Room room)
    {
        var result = await classroomRepository.AddClassroomAsync(room);

        return Ok();
    }

    [HttpGet("SearchClassrooms")]
    public async Task<IActionResult> GetClassroom()
    {
        var row = await classroomRepository.GetRow(1);

        if (row == null)
            return NotFound("No data found");

        return Ok(row);
    }
}