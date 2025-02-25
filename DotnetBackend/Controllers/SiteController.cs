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
    public async Task<IActionResult> GetSites([FromHeader(Name = "X-Api-Key")] string apiKey)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var clientName))
            return Unauthorized("Unauthorized");

        var sites = await siteRepository.GetUserSites(clientName!.Email);
        return Ok(sites);

    }

    [HttpGet("FindNearestSite")]
    public async Task<IActionResult> FindNearestSite([FromHeader(Name = "X-Api-Key")] string apiKey, double lat, double lon, double alt, string keyword = "", int limit = 10)
    {
        try
        {
            var site = await siteRepository.FindNearestSite(apiKey, lat, lon, alt, keyword, limit);

            if (site == null)
                return NotFound("No matching sites found");

            return Ok(site.Select(s => new AddSiteDTO(s)));
        }
        catch (Exception)
        {
            return StatusCode(500);
        }
    }

    [HttpPost("AddSite")]
    public async Task<IActionResult> AddSite([FromHeader(Name = "X-Api-Key")] string apiKey, [FromBody] AddSiteDTO addSite)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var clientName))
            return Unauthorized("Unauthorized");

        try
        {
            Site site = new Site(addSite);
            await siteRepository.AddSiteAsync(site);
            await siteRepository.AddUserToSiteAsync(clientName, site, UserRole.Admin);
            return Ok();
        }
        catch (Exception ex)
        {
            return StatusCode(500);
        }
    }

    [HttpPut("UpdateSite")]
    public async Task<IActionResult> UpdateSite(
        [FromHeader(Name = "X-Api-Key")] string apiKey,
        [FromBody] UpdateSiteDTO updateSite)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var clientName))
            return Unauthorized("Unauthorized");

        try
        {
            await siteRepository.UpdateSiteAsync(updateSite);
            return Ok();
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
    }



    [HttpDelete("DeleteSite")]
    public async Task<IActionResult> DeleteSite([FromHeader(Name = "X-Api-Key")] string apiKey, Guid guid)
    {
        if (!apiKeyService.ValidateApiKey(apiKey, out var clientName))
            return Unauthorized("Unauthorized");

        try
        {
            await siteRepository.DeleteSiteAsync(apiKey, guid);
            return Ok();
        }
        catch (Exception ex)
        {
            return StatusCode(500);
        }

    }
}