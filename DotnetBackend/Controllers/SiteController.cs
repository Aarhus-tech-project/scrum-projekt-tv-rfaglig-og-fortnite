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

    [HttpGet("GetEditSite")]
    public async Task<IActionResult> GetEditSite([FromHeader(Name = "X-Api-Key")] string apiKey, Guid siteID)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var user))
            return Unauthorized("Unauthorized");
        
        if (await siteRepository.GetUserSiteRole(user.ID, siteID) != UserRole.Admin)
            return Unauthorized("Unauthorized");

        var editSite = await siteRepository.GetEditSiteAsync(siteID);

        return Ok(editSite);
    }

    [HttpGet("GetUserSites")]
    public async Task<IActionResult> GetSites([FromHeader(Name = "X-Api-Key")] string apiKey)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var user)) 
            return Unauthorized("Unauthorized");

        var sites = await siteRepository.GetPublicUserSites(user.Email);
        return Ok(sites);

    }

    [HttpGet("FindNearestSite")]
    public async Task<IActionResult> FindNearestSite([FromHeader(Name = "X-Api-Key")] string apiKey, double lat, double lon, double alt, string keyword  = "", int limit = 10)
    {
        try
        {
            var site = await siteRepository.FindNearestSite(apiKey, lat, lon, alt, keyword, limit);

            if (site == null)
                return NotFound("No matching sites found");

            return Ok(site.Select(s => new PublicSiteDTO(s)));
        }
        catch (Exception)
        {
            return StatusCode(500);
        }
    }

    [HttpPost("Site")]
    public async Task<IActionResult> AddSite([FromHeader(Name = "X-Api-Key")] string apiKey, [FromBody]AddSiteDTO site)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var user)) 
            return Unauthorized("Unauthorized");

        try
        {            
            if (!site.Users.Any(u => u.Email == user.Email && u.Role == UserRole.Admin))
            {
                site.Users.Add(new AddEditUserSiteDTO(user.Email, UserRole.Admin));
            }

            await siteRepository.AddSiteAsync(site);

            return Ok();
        }
        catch (Exception ex)
        {
            return StatusCode(500);
        }
    }

    [HttpPut("Site")]
    public async Task<IActionResult> EditSite([FromHeader(Name = "X-Api-Key")] string apiKey, [FromBody] EditSiteDTO site)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var user))
            return Unauthorized("Unauthorized");
        
        if (await siteRepository.GetUserSiteRole(user.ID, site.ID) != UserRole.Admin)
            return Unauthorized("Unauthorized");

        try
        {
            await siteRepository.EditSiteAsync(site);
            return Ok();
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
    }



    [HttpDelete("Site")]
    public async Task<IActionResult> Site([FromHeader(Name = "X-Api-Key")] string apiKey, Guid siteID)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var user)) 
            return Unauthorized("Unauthorized");

        if (await siteRepository.GetUserSiteRole(user.ID, siteID) != UserRole.Admin)
            return Unauthorized("Unauthorized");

        try
        {
            await siteRepository.DeleteSiteAsync(siteID);
            return Ok();
        }
        catch (Exception ex)
        {
            return StatusCode(500);
        }

    }
}