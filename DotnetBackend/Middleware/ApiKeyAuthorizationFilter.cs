using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Linq;

public class ApiKeyAuthorizationFilter(ApiKeyService apiKeyService) : IAsyncAuthorizationFilter
{
    private readonly ApiKeyService apiKeyService = apiKeyService;

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

        if (!apiKeyService.ValidateApiKey(providedApiKey, out var clientName))
        {
            context.Result = new UnauthorizedObjectResult("Invalid or Expired API Key");
            return;
        }

        // Store client name in context (optional)
        context.HttpContext.Items["ClientName"] = clientName;
    }
}
