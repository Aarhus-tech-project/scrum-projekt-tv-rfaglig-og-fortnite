using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;

public class ApiKeyMiddleware(RequestDelegate next, ApiKeyService apiKeyService)
{
    private readonly RequestDelegate next = next;
    private readonly ApiKeyService apiKeyService = apiKeyService;

    public async Task Invoke(HttpContext context)
    {
        if (context.Request.Path.StartsWithSegments("/swagger") ||
            context.Request.Path.StartsWithSegments("/api-docs"))
        {
            await next(context);
            return;
        }

        if (!context.Request.Headers.TryGetValue("X-Api-Key", out var providedApiKey))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Missing API Key");
            return;
        }

        if (!apiKeyService.ValidateApiKey(providedApiKey, out var clientName))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Invalid or Expired API Key");
            return;
        }

        context.Items["ClientName"] = clientName;
        await next(context);
    }
}
