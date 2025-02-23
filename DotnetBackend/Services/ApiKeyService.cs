using System.Security.Cryptography;
using System.Text.Json;
using System.Text;

public class ApiKeyService
{
    private readonly string secretKey = "Datait2025!";

    public string GenerateApiKey(PublicUserDTO user, TimeSpan validity)
    {
        var payload = new
        {
            kid = Guid.NewGuid().ToString(),
            sub = user,
            exp = DateTimeOffset.UtcNow.Add(validity).ToUnixTimeSeconds()
        };

        string jsonPayload = JsonSerializer.Serialize(payload);
        string base64Payload = Convert.ToBase64String(Encoding.UTF8.GetBytes(jsonPayload));

        string signature = ComputeHmac(base64Payload, secretKey);
        return $"{base64Payload}.{signature}";
    }

    public bool ValidateApiKey(string apiKey, out PublicUserDTO user)
    {
        user = new PublicUserDTO();
        if (string.IsNullOrEmpty(apiKey) || !apiKey.Contains('.'))
            return false;

        string[] parts = apiKey.Split('.');
        if (parts.Length != 2)
            return false;

        string payload = Encoding.UTF8.GetString(Convert.FromBase64String(parts[0]));
        string signature = parts[1];

        // Verify signature
        if (ComputeHmac(parts[0], secretKey) != signature)
            return false;

        // Deserialize and check expiration
        var tokenData = JsonSerializer.Deserialize<JsonElement>(payload);
        if (tokenData.GetProperty("exp").GetInt64()<DateTimeOffset.UtcNow.ToUnixTimeSeconds())
            return false;

        user.Name = tokenData.GetProperty("sub").GetProperty("Name").GetString()!;
        user.Email = tokenData.GetProperty("sub").GetProperty("Email").GetString()!;
        user.CreatedAt = tokenData.GetProperty("sub").GetProperty("CreatedAt").GetDateTime()!;
        return true;
    }

    private static string ComputeHmac(string data, string secret)
    {
        using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(secret));
        byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(data));
        return Convert.ToBase64String(hash);
    }
}