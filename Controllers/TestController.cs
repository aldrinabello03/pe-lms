using Newtonsoft.Json.Linq;
using System;
using System.Web.Hosting;
using System.Web.Mvc;

namespace PELMS.Controllers
{
    public class TestController : Controller
    {
        // GET: Test
        public ActionResult VideoPage(string page)
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
                    nextPage = "Reaction Time";
                    previousPage = "Strength1";
                    break;
                case "Reaction Time":
                    nextPage = "Test for Speed";
                    previousPage = "Strength2";
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

            return View();
        }
    }
}
