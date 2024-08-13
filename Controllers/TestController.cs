using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;
using System.Web.UI;
using System.IO;
using System.Web.Hosting;
using Newtonsoft.Json.Linq;


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
                return RedirectToAction("VideoPage", new { page = "video1" });
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

            // Determine the next page using if-else statements
            string nextPage;
            if (page == "video1")
            {
                nextPage = "video2";
            }
            else if (page == "video2")
            {
                nextPage = "video3";
            }
            else
            {
                nextPage = "video1"; // Default to video1
            }

            // Pass data to the view
            ViewData["Title"] = title;
            ViewData["VideoPath"] = videoPath;
            ViewData["Description"] = description;
            ViewData["NextPage"] = nextPage;
            ViewData["Details"] = details;

            return View("VideoPage"); // Specify the view name if necessary
        }
    }
}