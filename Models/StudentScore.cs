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
        public int? BeforeHearthRate { get; set; }
        public int? AfterHearthRate { get; set; }
        public int? NumberOfPushUps { get; set; }
        public int? PlankTime { get; set; }
        public double? ZipperGap { get; set; }
        public double? SitAndReachFirstTry { get; set; }
        public double? SitAndReachSecondTry { get; set; }
        public int? JugglingHits { get; set; }
        public int? HexagonClockwise { get; set; }
        public int? HexagonCounterClockwise { get; set; }
        public double? SprintTime { get; set; }
        public int? LongJumpFirstTry { get; set; }
        public int? LongJumpSecondTry { get; set; }
        public int? BalanceRight { get; set; }
        public int? BalanceLeft { get; set; }
        public double? StickDrop1 { get; set; }
        public double? StickDrop2 { get; set; }
        public double? StickDrop3 { get; set; }
        public string TestTitle { get; set; }
        public string Interpretation { get; set; }
        public int UserAccountId { get;set; }
        public virtual UserAccount UserAccount { get; set; }
    }
}