using DotnetBackend.Models;
using DotnetBackend.Models.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
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

        var guidToBinaryConverter = new ValueConverter<Guid, byte[]>(
            guid => guid.ToByteArray(),
            bytes => new Guid(bytes) 
        );

        modelBuilder.Entity<Site>()
            .Property(e => e.ID)
            .HasColumnType("BINARY(16)")
            .HasConversion(guidToBinaryConverter)
            .HasDefaultValueSql("(UUID_TO_BIN(UUID()))");
        modelBuilder.Entity<Room>()
            .Property(e => e.ID)
            .HasColumnType("BINARY(16)")
            .HasConversion(guidToBinaryConverter)
            .HasDefaultValueSql("(UUID_TO_BIN(UUID()))");
        modelBuilder.Entity<User>()
            .Property(e => e.ID)
            .HasColumnType("BINARY(16)")
            .HasConversion(guidToBinaryConverter)
            .HasDefaultValueSql("(UUID_TO_BIN(UUID()))");
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

        modelBuilder.Entity<UserSite>()
            .Property(us => us.UserID)
            .HasColumnType("BINARY(16)")
            .HasConversion(guidToBinaryConverter);

        modelBuilder.Entity<UserSite>()
            .Property(us => us.SiteID)
            .HasColumnType("BINARY(16)")
            .HasConversion(guidToBinaryConverter);

    }
}