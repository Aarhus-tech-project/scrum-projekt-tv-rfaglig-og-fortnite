public class UserRepository
{
    private const string Users = "users";

    private readonly MySqlContext context;

    public UserRepository(MySqlContext context)
    {
        this.context = context;
    }
}