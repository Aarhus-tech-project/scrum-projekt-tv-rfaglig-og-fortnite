using System.Net.Http.Headers;
using DotnetBackend.Models;
using DotnetBackend.Models.DTOs;
using DotnetBackend.Models.Entities;
using DotnetBackend.Repositories;
using DotnetBackend.Services;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

namespace DotnetBackend.Controllers;

[Route("api")]
public class SiteController(SiteRepository siteRepository, ApiKeyService apiKeyService) : Controller
{
    [HttpGet("GetUserSites")]
    public async Task<IActionResult> GetSites ([FromHeader(Name = "X-Api-Key")] string apiKey)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var clientName)) 
            return Unauthorized("Unauthorized");

        var sites = await siteRepository.GetUserSites(clientName!);
        return Ok(sites);
    }

    [HttpPost("AddSite")]
    public async Task<IActionResult> AddSite([FromHeader(Name = "X-Api-Key")] string apiKey, [FromBody]SiteDTO site)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var clientName)) 
            return Unauthorized("Unauthorized");

        try
        {            
            var newSite = new Site(site);
            await siteRepository.AddSiteAsync(apiKey, newSite);
            await siteRepository.AddUserToSiteAsync(clientName, newSite, UserRole.Admin);
            return Ok();
        }
        catch (Exception ex)
        {
            return StatusCode(500);
        }
    }

    [HttpPost("FindNearestSite")]
    public async Task<IActionResult> FindNearestSite([FromHeader(Name = "X-Api-Key")] string apiKey, double lat, double lon, double alt, string keyword  = "", int limit = 10)
    {
        try
        {
            var site = await siteRepository.FindNearestSite(apiKey, lat, lon, alt, keyword, limit);

            if (site == null)
                return NotFound("No matching sites found");

            return Ok(site.Select(s => new SiteDTO(s)));
        }
        catch (Exception)
        {
            return StatusCode(500);
        }
    }
}