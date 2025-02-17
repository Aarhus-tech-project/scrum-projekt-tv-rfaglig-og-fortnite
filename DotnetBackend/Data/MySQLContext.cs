using DotnetBackend.Models;
using DotnetBackend.Models.Entities;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using System;
using System.Data;

namespace DotnetBackend.Data;

public class MySQLContext(DbContextOptions<MySQLContext> options) : DbContext(options)
{
    public DbSet<Room> Rooms { get; set; }
    public DbSet<User> Users { get; set; }
    public DbSet<Site> Sites { get; set; }
    public DbSet<UserSite> UserSites { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.Entity<Room>()
            .HasOne(r => r.Site)
            .WithMany()
            .HasForeignKey(r => r.SiteID)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<UserSite>()
            .HasKey(us => new { us.UserID, us.SiteID});

        modelBuilder.Entity<UserSite>()
            .HasOne(us => us.User)
            .WithMany ()
            .HasForeignKey(us => us.UserID);

        modelBuilder.Entity<UserSite>()
            .HasOne(us => us.Site)
            .WithMany ()
            .HasForeignKey(us => us.SiteID);
    }
}