public class ApiKeyMiddleware 
{
    private readonly RequestDelegate next;
    private readonly ApiKeyService apiKeyService;

    public ApiKeyMiddleware(RequestDelegate next, ApiKeyService apiKeyService)
    {
        this.next = next;
        this.apiKeyService = apiKeyService;
    }

    public async Task Invoke(HttpContext context)
    {
        if (!context.Request.Headers.TryGetValue("X-Api-Key", out var providedApiKey))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Missing API Key");
            return;
        }

        if (!apiKeyService.ValidateApiKey(providedApiKey!, out var clientName))
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("Invalid or Expired API Key");
            return;
        }

        context.Items["ClientName"] = clientName;
        await next(context);
    }
}