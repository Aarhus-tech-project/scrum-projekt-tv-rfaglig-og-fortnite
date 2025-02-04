using System.Net.Http.Headers;
using DotNetBackend.Models;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

[Route("api")]
public class ClassroomController : Controller
{
    MySqlContext mySqlContext;

    [HttpGet("Classrooms")]
    public async Task<IActionResult> GetClassrooms()
    {

        var navn = new List<Dictionary<string, object>>();
        navn = await mySqlContext.GetAllRowsAsync("rooms");

        mySqlContext.GetVariable("rooms", "1", "hans");

        return Ok(navn);

    }

    [HttpPost("Classrooms")]
    public async Task<IActionResult> AddClassroom([FromBody] Room room)
    {
        var result = await mySqlContext.AddClassroomAsync(room);

        return Ok();
    }

    [HttpGet("SearchClassrooms")]
    public async Task<IActionResult> GetClassroom()
    {
        var row = await mySqlContext.GetRow("rooms");

        if (row == null)
            return NotFound("No data found");

        return Ok(row);
    }


    public ClassroomController(MySqlContext mySqlContext)
    {
        this.mySqlContext = mySqlContext;
    }

}