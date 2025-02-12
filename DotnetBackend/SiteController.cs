using System.Net.Http.Headers;
using DotNetBackend.Models;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

public class SiteController(SiteRepository siteRepository, ApiKeyService apiKeyService) : Controller
{
    [HttpGet("GetUserSites")]
    public async Task<IActionResult> GetSites ([FromHeader(Name = "X-Api-Key")] string apiKey)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var clientName)) 
            return Unauthorized("Unauthorized");

       
        var sites = await siteRepository.GetUserSites(clientName);
        return Ok(sites);
    }
}