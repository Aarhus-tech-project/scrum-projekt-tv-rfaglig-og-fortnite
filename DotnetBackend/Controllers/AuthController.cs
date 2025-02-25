using DotnetBackend.Models;
using DotnetBackend.Models.DTOs;
using DotnetBackend.Models.Entities;
using DotnetBackend.Repositories;
using DotnetBackend.Services;
using Microsoft.AspNetCore.Mvc;

namespace DotnetBackend.Controllers;

[Route("api/auth")]
public class AuthController(UserRepository userRepository, ApiKeyService apiKeyService) : Controller
{
    [HttpPost("Register")]
    public async Task<IActionResult> Register([FromBody] RegisterUserDTO registerUser)
    {
        try
        {


            if (!EmailService.IsValidEmail(registerUser.Email))
                return BadRequest("Invalid Email");

            if (await userRepository.UserExists(registerUser.Email))
                return Conflict("User Already Exists");

            User user = await userRepository.RegisterUser(registerUser);
            registerUser.Dispose();


            return Ok();
        }
        catch (Exception ex)
        {
            return StatusCode(500);
        }
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login([FromBody] LoginRequestDTO loginRequest)
    {
        try
        {
            if (!EmailService.IsValidEmail(loginRequest.Email))
                return BadRequest("Invalid Email");

            if (!await userRepository.UserExists(loginRequest.Email))
                return NotFound("User Does Not Exist");

            User attemptedUser = await userRepository.GetUserFromEmail(loginRequest.Email);
            if (!PasswordHasher.VerifyPassword(loginRequest.Password, attemptedUser.PasswordHash))
                return Unauthorized("Wrong Password");

            loginRequest.Dispose();

            string apiKey = apiKeyService.GenerateApiKey(new PublicUserDTO(attemptedUser), TimeSpan.FromDays(30));
            return Ok(apiKey);
        }
        catch (Exception ex)
        {
            return StatusCode(500);
        }
    }

    [HttpDelete("DeleteAccount")]
    public async Task<IActionResult> DeleteAccount([FromHeader(Name = "X-Api-Key")] string apikey)
    {
        if (!apiKeyService.ValidateApiKey(apikey, out var user))

            return Unauthorized("Unauthorized");
        try
        {
            // Get the email of the currently logged-in user
            var loggedInUserEmail = User.FindFirst(user.Email)?.Value;

            // Validate that the provided email matches the logged-in user's email
            if (loggedInUserEmail == null || !loggedInUserEmail.Equals(user.Email, StringComparison.OrdinalIgnoreCase))
            {
                return Unauthorized("You can only delete your own account.");
            }

            var users = await userRepository.DeleteUserByEmail(user.Email);
            if (users == null)
            {
                return NotFound("User not found");
            }
            return Ok(users);
        }
        catch (Exception ex)
        {
            return StatusCode(500);
        }
    }

}