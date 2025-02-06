using DotNetBackend.Models;
using Microsoft.AspNetCore.Mvc;

[Route("api")]
public class UserController : Controller
{
    private readonly UserRepository userRepository;
    private readonly ApiKeyService apiKeyService;

    public UserController(UserRepository userRepository, ApiKeyService apiKeyService)
    {
        this.userRepository = userRepository;
        this.apiKeyService = apiKeyService;
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
        
        return Ok();   
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login([FromBody] LoginRequestDTO loginRequest)
    {
        if (!EmailService.IsValidEmail(loginRequest.Email))
            return BadRequest("Invalid Email");

        if (!await userRepository.UserExists(loginRequest.Email))
            return NotFound("User Does Not Exist");

        User attemptedUser = await userRepository.GetUserFromEmail(loginRequest.Email);
        if (!PasswordHasher.VerifyPassword(loginRequest.Password, attemptedUser.PasswordHash))
            return Unauthorized("Wrong Password");

        loginRequest.Dispose();

        string apiKey = apiKeyService.GenerateApiKey(attemptedUser.Email, TimeSpan.FromDays(30));
        return Ok(apiKey);
    }
}