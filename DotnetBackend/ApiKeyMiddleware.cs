using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;

public class ApiKeyMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ApiKeyService _apiKeyService;

    public ApiKeyMiddleware(RequestDelegate next, ApiKeyService apiKeyService)
    {
        _next = next;
        _apiKeyService = apiKeyService;
    }

    public async Task Invoke(HttpContext context)
    {
        if (context.Request.Path.StartsWithSegments("/swagger") ||
            context.Request.Path.StartsWithSegments("/api-docs"))
        {
            await _next(context);
            return;
        }

        if (!context.Request.Headers.TryGetValue("X-Api-Key", out var providedApiKey))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Missing API Key");
            return;
        }

        if (!_apiKeyService.ValidateApiKey(providedApiKey, out var clientName))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Invalid or Expired API Key");
            return;
        }

        context.Items["ClientName"] = clientName;
        await _next(context);
    }
}
