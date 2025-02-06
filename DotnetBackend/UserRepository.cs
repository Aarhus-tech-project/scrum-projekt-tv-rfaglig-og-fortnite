public class UserRepository
{
    private const string Users = "users";

    private readonly MySQLContext context;

    public UserRepository(MySQLContext context)
    {
        this.context = context;
    }
}