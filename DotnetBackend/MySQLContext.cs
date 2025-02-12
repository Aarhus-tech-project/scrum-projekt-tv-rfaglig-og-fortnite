using DotNetBackend.Models;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using System;
using System.Data;

public class MySQLContext : DbContext
{
    public MySQLContext (DbContextOptions<MySQLContext> options) : base(options) {}

    public DbSet<Room> Rooms { get; set; }
    public DbSet<User> Users { get; set; }
    public DbSet<Site> Sites { get; set; }
    public DbSet<UserSite> UserSites {get; set;}

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.Entity<Room>()
            .HasOne(r => r.Site)
            .WithMany(s => s.Rooms)
            .HasForeignKey(r => r.SiteID)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<DotNetBackend.Models.UserSite>()
            .HasKey(us => new { us.UserID, us.SiteID});

        modelBuilder.Entity<DotNetBackend.Models.UserSite>()
            .HasOne(us => us.User)
            .WithMany ()
            .HasForeignKey(us => us.UserID);

        modelBuilder.Entity<DotNetBackend.Models.UserSite>()
            .HasOne(us => us.Site)
            .WithMany ()
            .HasForeignKey(us => us.SiteID);
    }
}