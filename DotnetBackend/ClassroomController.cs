using System.Net.Http.Headers;
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
    public ClassroomController(MySqlContext mySqlContext)
    {
        this.mySqlContext = mySqlContext;
    }

}