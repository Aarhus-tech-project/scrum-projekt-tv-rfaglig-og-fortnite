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
        if (!EmailService.IsValidEmail(registerUser.Email))
            return BadRequest("Invalid Email");

        if (await userRepository.UserExists(registerUser.Email))
            return Conflict("User Already Exists");

        User user = await userRepository.RegisterUser(registerUser);
        registerUser.Dispose();
        
        return Ok(user);   
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
    {
        return Ok();
    }
    
}