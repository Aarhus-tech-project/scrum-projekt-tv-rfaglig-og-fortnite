using DotNetBackend.Models;
using Microsoft.AspNetCore.Mvc;

[Route("api")]
public class UserController : Controller
{
    private readonly UserRepository userRepository;

    public UserController(UserRepository userRepository)
    {
        this.userRepository = userRepository;
    }

    [HttpPost("Register")]
    public async Task<IActionResult> Register([FromBody] RegisterUserDTO registerUser)
    {
        User user = new(registerUser);
        var a = user.PasswordHash.Length;
        var password = PasswordHasher.VerifyPassword("strng", user.PasswordHash);
        registerUser.Dispose();

        return NotFound();
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
    {
        return Ok();
    }
    
}