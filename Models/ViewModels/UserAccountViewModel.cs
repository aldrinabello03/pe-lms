using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace PELMS.Models.ViewModels
{
    public class RegsitrationViewModel
    {
        [Key]
        public int Id { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string Role { get; set; }
    }

    public class StudentProfileViewModel
    {
        [Key]
        public int Id { get; set; }
        public string StudentNumber { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MiddleName { get; set; }
        public int Age { get; set; }
        public string Gender { get; set; }
        public string TeacherName { get; set; }
        public string School { get; set; }
        public string Level { get; set; }
        public string Section { get; set; }
        public double Weight { get; set; }
        public double Height { get; set; }
        public string BodyType { get; set; }
        public int UserAccountId { get; set; }
    }

    public class TeacherProfileViewModel
    {
        [Key]
        public int Id { get; set; }
        public string EmployeeNumber { get; set; }
        public string Title { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MiddleName { get; set; }
        public string School { get; set; }
        public int UserAccountId { get; set; }
    }

    public class LoginViewModel
    {
        public string UserName { get; set; }
        public string Password { get; set; }
    }

    public class UserSessionViewModel
    {
        public int Id { get; set; }
        public string Role { get; set; }
        public string UserName { get; set; }
        public string Name { get; set; }
        public string School { get; set; }        
        public int Age { get; set; }
        public int ProfileId { get; set; }
        public string Gender { get; set; }
    }

}