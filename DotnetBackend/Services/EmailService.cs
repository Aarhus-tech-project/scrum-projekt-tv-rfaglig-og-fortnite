using System.Text.RegularExpressions;

namespace DotnetBackend.Services;

public class EmailService
{
    public static bool IsValidEmail(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            return false;

        string pattern = @"^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|"
                   + @"([-a-zA-Z0-9!#$%&'*+/=?^_`{|}~]+(\.[-a-zA-Z0-9!#$%&'*+/=?^_`{|}~]+)*)"
                   + @")@([a-zA-Z0-9][a-zA-Z0-9-]*\.)+[a-zA-Z]{2,}$";

        return Regex.IsMatch(email, pattern, RegexOptions.IgnoreCase);
    }
}