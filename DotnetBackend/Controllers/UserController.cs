using DotnetBackend.Models.DTOs;
using DotnetBackend.Repositories;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace DotnetBackend.Controllers
{
    [Route("api/user")]
    public class UserController : Controller
    {
        private readonly UserRepository _userRepository;
        private readonly ApiKeyService _apiKeyService;

        public UserController(UserRepository userRepository, ApiKeyService apiKeyService)
        {
            _userRepository = userRepository;
            _apiKeyService = apiKeyService;
        }

        [HttpGet("UserData")]
        public async Task<IActionResult> FetchUserData([FromHeader(Name = "X-Api-Key")] string apiKey)
        {
            if (!_apiKeyService.ValidateApiKey(apiKey, out var clientName))
                return Unauthorized("Unauthorized");

            var user = await _userRepository.GetUserFromEmail(clientName!);
            var userDTO = new UserDTO(user);
            return Ok(userDTO);
        }
    }
}