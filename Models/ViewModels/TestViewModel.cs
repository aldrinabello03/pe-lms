using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace PELMS.Models.ViewModels
{
    public class UserScoreViewModel
    {
        [Key]
        public int Id { get; set; }
        public double Score { get; set; }
    }

}