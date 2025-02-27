﻿// <auto-generated />
using System;
using DotnetBackend.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace DotnetBackend.Migrations
{
    [DbContext(typeof(MySQLContext))]
    [Migration("20250225110613_InitiatCreate")]
    partial class InitiatCreate
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.2")
                .HasAnnotation("Relational:MaxIdentifierLength", 64);

            MySqlModelBuilderExtensions.AutoIncrementColumns(modelBuilder);

            modelBuilder.Entity("DotnetBackend.Models.Entities.Room", b =>
                {
                    b.Property<byte[]>("ID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("BINARY(16)")
                        .HasDefaultValueSql("(UUID_TO_BIN(UUID()))");

                    b.Property<double>("Alt")
                        .HasColumnType("double");

                    b.Property<double>("Lat")
                        .HasColumnType("double");

                    b.Property<int>("Level")
                        .HasColumnType("int");

                    b.Property<double>("Lon")
                        .HasColumnType("double");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(64)
                        .HasColumnType("varchar(64)");

                    b.Property<byte[]>("SiteID")
                        .IsRequired()
                        .HasColumnType("BINARY(16)");

                    b.HasKey("ID");

                    b.HasIndex("SiteID");

                    b.ToTable("Rooms");
                });

            modelBuilder.Entity("DotnetBackend.Models.Entities.Site", b =>
                {
                    b.Property<byte[]>("ID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("BINARY(16)")
                        .HasDefaultValueSql("(UUID_TO_BIN(UUID()))");

                    b.Property<string>("Address")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<double>("Alt")
                        .HasColumnType("double");

                    b.Property<bool>("IsPrivate")
                        .HasColumnType("tinyint(1)");

                    b.Property<double>("Lat")
                        .HasColumnType("double");

                    b.Property<double>("Lon")
                        .HasColumnType("double");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(128)
                        .HasColumnType("varchar(128)");

                    b.HasKey("ID");

                    b.ToTable("Sites");
                });

            modelBuilder.Entity("DotnetBackend.Models.Entities.User", b =>
                {
                    b.Property<byte[]>("ID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("BINARY(16)")
                        .HasDefaultValueSql("(UUID_TO_BIN(UUID()))");

                    b.Property<DateTime>("CreatedAt")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasMaxLength(128)
                        .HasColumnType("varchar(128)");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(64)
                        .HasColumnType("varchar(64)");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasMaxLength(128)
                        .HasColumnType("varchar(128)");

                    b.HasKey("ID");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("DotnetBackend.Models.Entities.UserSite", b =>
                {
                    b.Property<byte[]>("UserID")
                        .HasColumnType("BINARY(16)");

                    b.Property<byte[]>("SiteID")
                        .HasColumnType("BINARY(16)");

                    b.Property<int>("Role")
                        .HasColumnType("int");

                    b.HasKey("UserID", "SiteID");

                    b.HasIndex("SiteID");

                    b.ToTable("UserSites");
                });

            modelBuilder.Entity("DotnetBackend.Models.Entities.Room", b =>
                {
                    b.HasOne("DotnetBackend.Models.Entities.Site", "Site")
                        .WithMany()
                        .HasForeignKey("SiteID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Site");
                });

            modelBuilder.Entity("DotnetBackend.Models.Entities.UserSite", b =>
                {
                    b.HasOne("DotnetBackend.Models.Entities.Site", "Site")
                        .WithMany()
                        .HasForeignKey("SiteID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("DotnetBackend.Models.Entities.User", "User")
                        .WithMany()
                        .HasForeignKey("UserID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Site");

                    b.Navigation("User");
                });
#pragma warning restore 612, 618
        }
    }
}
