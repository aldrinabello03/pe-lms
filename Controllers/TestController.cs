using Microsoft.Win32;
using Newtonsoft.Json.Linq;
using PELMS.DAL;
using PELMS.Models;
using PELMS.Models.ViewModels;
using System;
using System.Data.Entity;
using System.Linq;
using System.Web.Hosting;
using System.Web.Mvc;
using System.Web.UI;

namespace PELMS.Controllers
{
    public class TestController : Controller
    {
        // GET: Test
        public ActionResult VideoPage(string page)
        {
            using (var dbCon = new LMSDBContext())
            {
                // Check if the page parameter is null or empty
                if (string.IsNullOrEmpty(page))
                {
                    // Redirect to the default video page (Body Composition)
                    return RedirectToAction("VideoPage", new { page = "Body Composition" });
                }

                // Load the JSON file content
                string jsonFilePath = HostingEnvironment.MapPath("~/Content/Others/VideoDescriptions.json");
                var jsonData = System.IO.File.ReadAllText(jsonFilePath);
                var videoData = JObject.Parse(jsonData);

                // Handle pages with Flexibility and Strength references
                if (page == "Flexibility")
                {
                    page = "Flexibility1"; // Default to Flexibility1
                }
                else if (page == "Strength")
                {
                    page = "Strength1"; // Default to Strength1
                }

                // Extract data for the given page
                var videoInfo = videoData[page];
                if (videoInfo == null)
                {
                    return HttpNotFound(); // Page not found
                }

                // Extract information from JSON
                string title = videoInfo["title"]?.ToString();
                string purpose = videoInfo["Purpose"]?.ToString();
                string formula = videoInfo["Formula"]?.ToString();

                // Safely handle null values for Equipment
                var equipmentArray = videoInfo["Equipment"]?.ToObject<string[]>();
                string equipment = equipmentArray != null ? string.Join(", ", equipmentArray) : "No equipment listed";

                // Safely handle null values for ProcedureTester
                var procedureTesterArray = videoInfo["Procedure"]?["For the Tester"]?.ToObject<string[]>();
                string procedureTester = procedureTesterArray != null ? string.Join("<br/>", procedureTesterArray) : "No procedure for the tester";

                // Safely handle null values for ProcedurePartner
                var procedurePartnerArray = videoInfo["Procedure"]?["For the Partner"]?.ToObject<string[]>();
                string procedurePartner = procedurePartnerArray != null ? string.Join("<br/>", procedurePartnerArray) : "No procedure for the partner";

                string scoring = videoInfo["Scoring"]?.ToString();

                // Set local video paths based on the 'page' parameter
                string videoPath;
                if (page == "Flexibility1" || page == "Flexibility2")
                {
                    videoPath = Url.Content($"~/Content/Videos/Flexibility.mp4"); // Both Flexibility1 and Flexibility2 use the same video
                }
                else if (page == "Strength1" || page == "Strength2")
                {
                    videoPath = Url.Content($"~/Content/Videos/Strength.mp4"); // Both Strength1 and Strength2 use the same video
                }
                else
                {
                    videoPath = Url.Content($"~/Content/Videos/{page}.mp4"); // Other videos
                }

                // Determine the next and previous pages using a switch statement
                string nextPage;
                string previousPage;
                switch (page)
                {
                    case "Body Composition":
                        nextPage = "Balance";
                        previousPage = "Test for Speed"; // Loop back to the last video
                        break;
                    case "Balance":
                        nextPage = "Cardio Vascular Endurance";
                        previousPage = "Body Composition";
                        break;
                    case "Cardio Vascular Endurance":
                        nextPage = "Coordination";
                        previousPage = "Balance";
                        break;
                    case "Coordination":
                        nextPage = "Flexibility1";
                        previousPage = "Cardio Vascular Endurance";
                        break;
                    case "Flexibility1":
                        nextPage = "Flexibility2";
                        previousPage = "Coordination";
                        break;
                    case "Flexibility2":
                        nextPage = "Strength1";
                        previousPage = "Flexibility1";
                        break;
                    case "Strength1":
                        nextPage = "Strength2";
                        previousPage = "Flexibility2";
                        break;
                    case "Strength2":
                        nextPage = "Power";
                        previousPage = "Strength1";
                        break;
                    case "Power":
                        nextPage = "Reaction Time";
                        previousPage = "Strength2";
                        break;
                    case "Reaction Time":
                        nextPage = "Test for Speed";
                        previousPage = "Power";
                        break;
                    case "Test for Speed":
                        nextPage = "Body Composition"; // Loop back to the first video
                        previousPage = "Reaction Time";
                        break;
                    default:
                        nextPage = "Body Composition";
                        previousPage = "Test for Speed";
                        break;
                }

                // Pass the extracted data to the View
                ViewBag.Title = title;
                ViewBag.Purpose = purpose;
                ViewBag.Formula = formula;
                ViewBag.Equipment = equipment;
                ViewBag.ProcedureTester = procedureTester;
                ViewBag.ProcedurePartner = procedurePartner;
                ViewBag.Scoring = scoring;
                ViewBag.VideoPath = videoPath;
                ViewBag.NextPage = nextPage;
                ViewBag.PreviousPage = previousPage;

                var user = (UserSessionViewModel)Session["UserLogged"];
                var isDone = false;
                var student = dbCon.UserAccounts.Include(x => x.Scores).Include(x => x.StudentProfile).Where(x => x.Id == user.Id).FirstOrDefault();

                if (student != null)
                {
                    if (student.Scores.Any(x => x.TestTitle == title))
                        isDone = true;

                    if (student.StudentProfile.FirstOrDefault() != null && title == "Body Mass Index")
                    {
                        if (!string.IsNullOrEmpty(student.StudentProfile.FirstOrDefault().BodyType))
                            isDone = true;
                    }
                }

                var viewModel = new StudentScoreViewModel
                {
                    TestTitle = title,
                    NextPage = nextPage,
                    IsDone = isDone
                };

                return View(viewModel);
            }            
        }

        [HttpPost]
        public ActionResult VideoPage(StudentScoreViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                using (var dbCon = new LMSDBContext())
                {
                    var user = (UserSessionViewModel)Session["UserLogged"];
                    string interpretatation = "";

                    switch (viewModel.TestTitle)
                    {
                        case "Body Mass Index":
                            var bmi = viewModel.Weight.Value / (viewModel.Height.Value * viewModel.Height.Value);
                            var classification = "";

                            if (bmi < 18.5)
                            {
                                classification = "UNDERWEIGHT";
                            }
                            else if (bmi >= 18.5 && bmi <= 24.9)
                            {
                                classification = "NORMAL";
                            }
                            else if (bmi >= 25 && bmi <= 29.9)
                            {
                                classification = "OVERWEIGHT";
                            }
                            else if (bmi >= 30)
                            {
                                classification = "OBESE";
                            }

                            var studentProfile = dbCon.StudentProfiles.Where(x => x.Id == user.ProfileId).FirstOrDefault();

                            if (studentProfile != null)
                            {
                                studentProfile.Weight = viewModel.Weight.Value;
                                studentProfile.Height = viewModel.Height.Value;
                                studentProfile.BodyType = Math.Round(bmi, 2).ToString() + " - " + classification;
                                dbCon.Entry(studentProfile).State = EntityState.Modified;
                                dbCon.SaveChanges();
                            }

                            break;
                        case "Stork Balance Stand Test":
                            var average = (viewModel.BalanceLeft + viewModel.BalanceRight) / 2;
                            if (user.Age >= 9 && user.Age <= 12)
                            {
                                if (average >= 41 && average <= 60)
                                    interpretatation = "Excellent";
                                else if (average >= 31 && average <= 40)
                                    interpretatation = "Very Good";
                                else if (average >= 21 && average <= 30)
                                    interpretatation = "Good";
                                else if (average >= 11 && average <= 20)
                                    interpretatation = "Fair";
                                else if (average >= 1 && average <= 10)
                                    interpretatation = "Needs Improvement";
                            }
                            else if (user.Age >= 13 && user.Age <= 14)
                            {
                                if (average >= 81 && average <= 100)
                                    interpretatation = "Excellent";
                                else if (average >= 61 && average <= 80)
                                    interpretatation = "Very Good";
                                else if (average >= 41 && average <= 60)
                                    interpretatation = "Good";
                                else if (average >= 21 && average <= 40)
                                    interpretatation = "Fair";
                                else if (average >= 1 && average <= 20)
                                    interpretatation = "Needs Improvement";
                            }
                            else if (user.Age >= 15 && user.Age <= 16)
                            {
                                if (average >= 121 && average <= 150)
                                    interpretatation = "Excellent";
                                else if (average >= 91 && average <= 120)
                                    interpretatation = "Very Good";
                                else if (average >= 61 && average <= 90)
                                    interpretatation = "Good";
                                else if (average >= 31 && average <= 60)
                                    interpretatation = "Fair";
                                else if (average >= 1 && average <= 30)
                                    interpretatation = "Needs Improvement";
                            }
                            else if (user.Age >= 17)
                            {
                                if (average >= 161 && average <= 180)
                                    interpretatation = "Excellent";
                                else if (average >= 121 && average <= 160)
                                    interpretatation = "Very Good";
                                else if (average >= 81 && average <= 120)
                                    interpretatation = "Good";
                                else if (average >= 41 && average <= 80)
                                    interpretatation = "Fair";
                                else if (average >= 1 && average <= 40)
                                    interpretatation = "Needs Improvement";
                            }
                            break;
                        case "3-Minute Step Test":
                            break;
                        case "Juggling":
                            if (viewModel.JugglingHits >= 41)
                                interpretatation = "Excellent";
                            else if (viewModel.JugglingHits >= 31 && viewModel.JugglingHits <= 40)
                                interpretatation = "Very Good";
                            else if (viewModel.JugglingHits >= 21 && viewModel.JugglingHits <= 30)
                                interpretatation = "Good";
                            else if (viewModel.JugglingHits >= 11 && viewModel.JugglingHits <= 20)
                                interpretatation = "Fair";
                            else if (viewModel.JugglingHits >= 1 && viewModel.JugglingHits <= 10)
                                interpretatation = "Needs Improvement";
                            break;
                        case "Zipper Test":
                            var gap = Math.Abs(viewModel.LeftZipper.Value -  viewModel.RightZipper.Value);
                            if (gap >= 6)
                                interpretatation = "Excellent";
                            else if (gap >= 4 && gap <= 5.9)
                                interpretatation = "Very Good";
                            else if (gap >= 2 && gap <= 3.9)
                                interpretatation = "Good";
                            else if (gap >= 0.1 && gap <= 1.9)
                                interpretatation = "Fair";
                            else if (gap < 0.1)
                                interpretatation = "Needs Improvement";
                            else
                                interpretatation = "Poor";
                            break;
                        case "Sit and Reach":
                            var highest = viewModel.SitAndReachFirstTry >= viewModel.SitAndReachSecondTry ? viewModel.SitAndReachFirstTry : viewModel.SitAndReachSecondTry;
                            if (highest >= 61)
                                interpretatation = "Excellent";
                            else if (highest >= 46 && highest <= 60.9)
                                interpretatation = "Very Good";
                            else if (highest >= 31 && highest <= 45.9)
                                interpretatation = "Good";
                            else if (highest >= 16 && highest <= 30.9)
                                interpretatation = "Fair";
                            else if (highest >= 0 && highest <=15.9)
                                interpretatation = "Needs Improvement";
                            break;
                        case "Standing Long Jump":
                            var highestjump = viewModel.LongJumpFirstTry >= viewModel.LongJumpSecondTry ? viewModel.LongJumpFirstTry : viewModel.LongJumpSecondTry;
                            if (highestjump >= 201)
                                interpretatation = "Excellent";
                            else if (highestjump >= 151 && highestjump <= 200)
                                interpretatation = "Very Good";
                            else if (highestjump >= 126 && highestjump <= 150)
                                interpretatation = "Good";
                            else if (highestjump >= 101 && highestjump <= 125)
                                interpretatation = "Fair";
                            else if (highestjump >= 55 && highestjump <= 100)
                                interpretatation = "Needs Improvement";
                            break;
                        case "Stick Drop Test":
                            var middle = viewModel.StickDrop1;
                            if (viewModel.StickDrop1 >= viewModel.StickDrop2 && viewModel.StickDrop1 <= viewModel.StickDrop3)
                                middle = viewModel.StickDrop1;
                            else if (viewModel.StickDrop1 >= viewModel.StickDrop3 && viewModel.StickDrop1 <= viewModel.StickDrop2)
                                middle = viewModel.StickDrop1;
                            else if (viewModel.StickDrop2 >= viewModel.StickDrop3 && viewModel.StickDrop2 <= viewModel.StickDrop1)
                                middle = viewModel.StickDrop2;
                            else if (viewModel.StickDrop2 >= viewModel.StickDrop1 && viewModel.StickDrop2 <= viewModel.StickDrop3)
                                middle = viewModel.StickDrop2;
                            else if (viewModel.StickDrop3 >= viewModel.StickDrop1 && viewModel.StickDrop3 <= viewModel.StickDrop2)
                                middle = viewModel.StickDrop3;
                            else if (viewModel.StickDrop3 >= viewModel.StickDrop2 && viewModel.StickDrop3 <= viewModel.StickDrop1)
                                middle = viewModel.StickDrop3;

                            if (middle >= 0 && middle <= 2.4)
                                interpretatation = "Excellent";
                            else if (middle >= 5.08 && middle <= 10.16)
                                interpretatation = "Very Good";
                            else if (middle >= 12.70 && middle <= 17.78)
                                interpretatation = "Good";
                            else if (middle >= 20.32 && middle <= 25.40)
                                interpretatation = "Fair";
                            else if (middle >= 27.94 && middle <= 30.48)
                                interpretatation = "Needs Improvement";
                            else
                                interpretatation = "Poor";
                            break;
                        case "Push up":
                            if (user.Gender.ToLower() == "male")
                            {
                                if (viewModel.NumberOfPushUps >= 33)
                                    interpretatation = "Excellent";
                                else if (viewModel.NumberOfPushUps >= 25 && viewModel.NumberOfPushUps <= 32)
                                    interpretatation = "Very Good";
                                else if (viewModel.NumberOfPushUps >= 17 && viewModel.NumberOfPushUps <= 24)
                                    interpretatation = "Good";
                                else if (viewModel.NumberOfPushUps >= 9 && viewModel.NumberOfPushUps <= 16)
                                    interpretatation = "Fair";
                                else if (viewModel.NumberOfPushUps >= 1 && viewModel.NumberOfPushUps <= 8)
                                    interpretatation = "Needs Improvement";
                                else
                                    interpretatation = "Poor";
                            }
                            else
                            {
                                if (viewModel.NumberOfPushUps >= 33)
                                    interpretatation = "Excellent";
                                else if (viewModel.NumberOfPushUps >= 25 && viewModel.NumberOfPushUps <= 32)
                                    interpretatation = "Very Good";
                                else if (viewModel.NumberOfPushUps >= 17 && viewModel.NumberOfPushUps <= 24)
                                    interpretatation = "Good";
                                else if (viewModel.NumberOfPushUps >= 9 && viewModel.NumberOfPushUps <= 16)
                                    interpretatation = "Fair";
                                else if (viewModel.NumberOfPushUps >= 1 && viewModel.NumberOfPushUps <= 8)
                                    interpretatation = "Needs Improvement";
                                else
                                    interpretatation = "Poor";
                            }
                            break;
                        case "Basic Plank":
                            if (viewModel.PlankTime >= 51)
                                interpretatation = "Excellent";
                            else if (viewModel.PlankTime >= 46 && viewModel.PlankTime <= 50)
                                interpretatation = "Very Good";
                            else if (viewModel.PlankTime >= 31 && viewModel.PlankTime <= 45)
                                interpretatation = "Good";
                            else if (viewModel.PlankTime >= 16 && viewModel.PlankTime <= 30)
                                interpretatation = "Fair";
                            else if (viewModel.PlankTime >= 1 && viewModel.PlankTime <= 15)
                                interpretatation = "Needs Improvement";
                            break;
                        case "40-Meter Sprint":
                            if (user.Gender.ToLower() == "male")
                            {
                                if (user.Age >= 9 && user.Age <= 12)
                                {
                                    if (viewModel.SprintTime < 6)
                                        interpretatation = "Excellent";
                                    else if (viewModel.SprintTime >= 6.1 && viewModel.SprintTime <= 7.7)
                                        interpretatation = "Very Good";
                                    else if (viewModel.SprintTime >= 7.8 && viewModel.SprintTime <= 8.5)
                                        interpretatation = "Good";
                                    else if (viewModel.SprintTime >= 8.6 && viewModel.SprintTime <= 9.5)
                                        interpretatation = "Fair";
                                    else if (viewModel.SprintTime >= 9.6)
                                        interpretatation = "Needs Improvement";
                                }
                                else if (user.Age >= 13 && user.Age <= 14)
                                {
                                    if (viewModel.SprintTime < 5)
                                        interpretatation = "Excellent";
                                    else if (viewModel.SprintTime >= 5.1 && viewModel.SprintTime <= 6.9)
                                        interpretatation = "Very Good";
                                    else if (viewModel.SprintTime >= 7 && viewModel.SprintTime <= 8)
                                        interpretatation = "Good";
                                    else if (viewModel.SprintTime >= 8.1 && viewModel.SprintTime <= 9.1)
                                        interpretatation = "Fair";
                                    else if (viewModel.SprintTime >= 9.2)
                                        interpretatation = "Needs Improvement";
                                }
                                else if (user.Age >= 15 && user.Age <= 16)
                                {
                                    if (viewModel.SprintTime < 4.5)
                                        interpretatation = "Excellent";
                                    else if (viewModel.SprintTime >= 4.6 && viewModel.SprintTime <= 5.4)
                                        interpretatation = "Very Good";
                                    else if (viewModel.SprintTime >= 5.5 && viewModel.SprintTime <= 7)
                                        interpretatation = "Good";
                                    else if (viewModel.SprintTime >= 7.1 && viewModel.SprintTime <= 8.1)
                                        interpretatation = "Fair";
                                    else if (viewModel.SprintTime >= 8.2)
                                        interpretatation = "Needs Improvement";
                                }
                                else if (user.Age >= 17)
                                {
                                    if (viewModel.SprintTime < 4)
                                        interpretatation = "Excellent";
                                    else if (viewModel.SprintTime >= 4.1 && viewModel.SprintTime <= 5.4)
                                        interpretatation = "Very Good";
                                    else if (viewModel.SprintTime >= 5.5 && viewModel.SprintTime <= 6.5)
                                        interpretatation = "Good";
                                    else if (viewModel.SprintTime >= 6.6 && viewModel.SprintTime <= 7.5)
                                        interpretatation = "Fair";
                                    else if (viewModel.SprintTime >= 7.6)
                                        interpretatation = "Needs Improvement";
                                }
                            }
                            else
                            {
                                if (user.Age >= 9 && user.Age <= 12)
                                {
                                    if (viewModel.SprintTime < 7)
                                        interpretatation = "Excellent";
                                    else if (viewModel.SprintTime >= 7.1 && viewModel.SprintTime <= 8.4)
                                        interpretatation = "Very Good";
                                    else if (viewModel.SprintTime >= 8.5 && viewModel.SprintTime <= 9.5)
                                        interpretatation = "Good";
                                    else if (viewModel.SprintTime >= 9.6 && viewModel.SprintTime <= 10.5)
                                        interpretatation = "Fair";
                                    else if (viewModel.SprintTime >= 10.6)
                                        interpretatation = "Needs Improvement";
                                }
                                else if (user.Age >= 13 && user.Age <= 14)
                                {
                                    if (viewModel.SprintTime < 6.5)
                                        interpretatation = "Excellent";
                                    else if (viewModel.SprintTime >= 6.6 && viewModel.SprintTime <= 7.6)
                                        interpretatation = "Very Good";
                                    else if (viewModel.SprintTime >= 7.7 && viewModel.SprintTime <= 8.8)
                                        interpretatation = "Good";
                                    else if (viewModel.SprintTime >= 8.9 && viewModel.SprintTime <= 9.5)
                                        interpretatation = "Fair";
                                    else if (viewModel.SprintTime >= 9.6)
                                        interpretatation = "Needs Improvement";
                                }
                                else if (user.Age >= 15 && user.Age <= 16)
                                {
                                    if (viewModel.SprintTime < 5.5)
                                        interpretatation = "Excellent";
                                    else if (viewModel.SprintTime >= 5.6 && viewModel.SprintTime <= 6.1)
                                        interpretatation = "Very Good";
                                    else if (viewModel.SprintTime >= 6.2 && viewModel.SprintTime <= 7.2)
                                        interpretatation = "Good";
                                    else if (viewModel.SprintTime >= 7.3 && viewModel.SprintTime <= 8.5)
                                        interpretatation = "Fair";
                                    else if (viewModel.SprintTime >= 8.6)
                                        interpretatation = "Needs Improvement";
                                }
                                else if (user.Age >= 17)
                                {
                                    if (viewModel.SprintTime < 4.5)
                                        interpretatation = "Excellent";
                                    else if (viewModel.SprintTime >= 4.6 && viewModel.SprintTime <= 5.9)
                                        interpretatation = "Very Good";
                                    else if (viewModel.SprintTime >= 6 && viewModel.SprintTime <= 7)
                                        interpretatation = "Good";
                                    else if (viewModel.SprintTime >= 7.1 && viewModel.SprintTime <= 8.1)
                                        interpretatation = "Fair";
                                    else if (viewModel.SprintTime >= 8.2)
                                        interpretatation = "Needs Improvement";
                                }
                            }
                            break;
                    }

                    if (viewModel.TestTitle != "Body Mass Index")
                    {
                        var score = new StudentScore
                        {
                            BeforeHearthRate = viewModel.BeforeHearthRate,
                            AfterHearthRate = viewModel.AfterHearthRate,
                            NumberOfPushUps = viewModel.NumberOfPushUps,
                            PlankTime = viewModel.PlankTime,
                            RightZipper = viewModel.RightZipper,
                            LeftZipper = viewModel.LeftZipper,
                            SitAndReachFirstTry = viewModel.SitAndReachFirstTry,
                            SitAndReachSecondTry = viewModel.SitAndReachSecondTry,
                            JugglingHits = viewModel.JugglingHits,
                            HexagonClockwise = viewModel.HexagonClockwise,
                            HexagonCounterClockwise = viewModel.HexagonCounterClockwise,
                            SprintTime = viewModel.SprintTime,
                            LongJumpFirstTry = viewModel.LongJumpFirstTry,
                            LongJumpSecondTry = viewModel.LongJumpSecondTry,
                            BalanceRight = viewModel.BalanceRight,
                            BalanceLeft = viewModel.BalanceLeft,
                            StickDrop1 = viewModel.StickDrop1,
                            StickDrop2 = viewModel.StickDrop2,
                            StickDrop3 = viewModel.StickDrop3,
                            UserAccountId = user.Id,
                            TestTitle = viewModel.TestTitle,
                            Interpretation = interpretatation
                        };

                        dbCon.StudentScores.Add(score);
                        dbCon.SaveChanges();
                    }
                    
                    return RedirectToAction("VideoPage", new { page = viewModel.NextPage });

                }
            }

            return View(viewModel);
        }
    }
}
