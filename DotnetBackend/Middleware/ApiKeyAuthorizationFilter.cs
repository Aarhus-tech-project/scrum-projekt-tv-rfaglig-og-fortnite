using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Linq;
using DotnetBackend.Services;

namespace DotnetBackend.Middleware;

public class ApiKeyAuthorizationFilter(ApiKeyService apiKeyService) : IAsyncAuthorizationFilter
{
    public async Task OnAuthorizationAsync(AuthorizationFilterContext context)
    {
        var endpoint = context.HttpContext.GetEndpoint();
        var hasAuthorizeAttribute = endpoint?.Metadata?.GetMetadata<AuthorizeAttribute>() != null;

        if (!hasAuthorizeAttribute)
        {
            // If there's NO [Authorize] attribute, skip API key check
            return;
        }

        // Extract API key from headers
        if (!context.HttpContext.Request.Headers.TryGetValue("X-Api-Key", out var providedApiKey))
        {
            context.Result = new UnauthorizedObjectResult("Missing API Key");
            return;
        }

        if (!apiKeyService.ValidateApiKey(providedApiKey!, out var clientName))
        {
            context.Result = new UnauthorizedObjectResult("Invalid or Expired API Key");
            return;
        }

        // Store client name in context (optional)
        context.HttpContext.Items["ClientName"] = clientName;
    }
}
