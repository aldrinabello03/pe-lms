using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace PELMS.Models
{
    public class StudentScore
    {
        [Key]
        public int Id { get; set; }
        public int TestId { get; set; }
        public int Score { get; set; }
        public int Total { get; set; }
        public string Interpretation { get; set; }
        public int UserAccountId { get; set; }
        public virtual UserAccount UserAccount { get; set; }
    }
}