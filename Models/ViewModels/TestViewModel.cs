using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace PELMS.Models.ViewModels
{
    public class StudentScoreViewModel
    {
        [Key]
        public int Id { get; set; }
        public double? Height { get; set; }
        public double? Weight { get; set; }
        public int? BeforeHearthRate { get; set; }
        public int? AfterHearthRate { get; set; }
        public int? NumberOfPushUps { get; set; }
        public int? PlankTime { get; set; }
        public double? RightZipper { get; set; }
        public double? LeftZipper { get; set; }
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
        public string NextPage { get; set; }
        public string Interpretation { get; set; }
        public bool IsDone { get; set; }
        
    }

    public class StudentScoreDashBoardViewModel
    {
        [Key]
        public int Id { get; set; }
        public double? Height { get; set; }
        public double? Weight { get; set; }
        public int? BeforeHearthRate { get; set; }
        public int? AfterHearthRate { get; set; }
        public int? NumberOfPushUps { get; set; }
        public int? PlankTime { get; set; }
        public double? RightZipper { get; set; }
        public double? LeftZipper { get; set; }
        public double? SitAndReachFirstTry { get; set; }
        public double? SitAndReachSecondTry { get; set; }
        public double? SitAndReachBestScore { get; set; }
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
        public string NextPage { get; set; }
        public string BMIInterpretation { get; set; }
        public string PushUpInterpretation { get; set; }
        public string PlankInterpretation { get; set; }
        public string ZipperInterpretation { get; set; }
        public string SitAndReachInterpretation { get; set; }
        public string JugglingInterpretation { get; set; }
        public string SprintInterpretation { get; set; }
        public string LongJumpInterpretation { get; set; }
        public string BalanceInterpretation { get; set; }
        public string StickDropInterpretation { get; set; }
        public string StudentName {  get; set; }

    }

}