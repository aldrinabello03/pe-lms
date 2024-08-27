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
                // Redirect to the default video page
                return RedirectToAction("VideoPage", new { page = "Balance" });
            }

            // Load the JSON file content
            string jsonFilePath = HostingEnvironment.MapPath("~/Content/Others/VideoDescriptions.json");
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);
            var videoData = JObject.Parse(jsonData);

            // Extract data for the given page
            var videoInfo = videoData[page];
            if (videoInfo == null)
            {
                return HttpNotFound(); // Page not found
            }

            string title = videoInfo["title"].ToString();
            string description = videoInfo["description"].ToString();
            string details = videoInfo["details"].ToString();

            // Set local video paths based on the 'page' parameter
            string videoPath = Url.Content($"~/Content/Videos/{page}.mp4");

            // Determine the next and previous pages using a switch statement
            string nextPage;
            string previousPage;
            switch (page)
            {
                case "Balance":
                    nextPage = "Cardio Vascular Endurance";
                    previousPage = "Test for Speed"; // Loop back to the last video
                    break;
                case "Cardio Vascular Endurance":
                    nextPage = "Coordination";
                    previousPage = "Balance";
                    break;
                case "Coordination":
                    nextPage = "Flexibility";
                    previousPage = "Cardio Vascular Endurance";
                    break;
                case "Flexibility":
                    nextPage = "Power";
                    previousPage = "Coordination";
                    break;
                case "Power":
                    nextPage = "Reaction Time";
                    previousPage = "Flexibility";
                    break;
                case "Reaction Time":
                    nextPage = "Strength";
                    previousPage = "Power";
                    break;
                case "Strength":
                    nextPage = "Test for Speed";
                    previousPage = "Reaction Time";
                    break;
                case "Test for Speed":
                    nextPage = "Balance"; // Loop back to the first video
                    previousPage = "Strength";
                    break;
                default:
                    nextPage = "Balance"; // Default to Balance
                    previousPage = "Test for Speed"; // Loop back to the last video
                    break;
            }

            // Pass data to the view
            ViewData["Title"] = title;
            ViewData["VideoPath"] = videoPath;
            ViewData["Description"] = description;
            ViewData["NextPage"] = nextPage;
            ViewData["PreviousPage"] = previousPage;
            ViewData["Details"] = details;

            return View("VideoPage"); // Specify the view name if necessary
        }
    }
}
