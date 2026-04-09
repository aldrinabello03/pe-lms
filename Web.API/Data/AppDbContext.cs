using Microsoft.EntityFrameworkCore;
using Web.API.Models;

namespace Web.API.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<UserAccount> UserAccounts { get; set; }
    public DbSet<StudentProfile> StudentProfiles { get; set; }
    public DbSet<TeacherProfile> TeacherProfiles { get; set; }
    public DbSet<StudentScore> StudentScores { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Map to exact same non-pluralized table names
        modelBuilder.Entity<UserAccount>().ToTable("UserAccount");
        modelBuilder.Entity<StudentProfile>().ToTable("StudentProfile");
        modelBuilder.Entity<TeacherProfile>().ToTable("TeacherProfile");
        modelBuilder.Entity<StudentScore>().ToTable("StudentScore");
    }
}
