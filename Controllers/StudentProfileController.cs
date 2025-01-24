using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using PELMS.DAL;
using PELMS.Models;
using PELMS.Models.ViewModels;

namespace PELMS.Controllers
{
    public class StudentProfileController : Controller
    {
        private LMSDBContext db = new LMSDBContext();

        // GET: StudentProfile
        public ActionResult Index()
        {
            using (var dbCon = new LMSDBContext())
            {
                var userSession = (UserSessionViewModel)Session["UserLogged"];
                var list = new List<StudentProfileViewModel>();

                if (userSession.Role == "Teacher")
                {
                    var studentProfiles = dbCon.StudentProfiles
                        .Include(s => s.UserAccount)
                        .Where(x => x.TeacherName == userSession.Name)
                        .ToList();

                    list = (from studentProfile in studentProfiles
                            select new StudentProfileViewModel()
                            {
                                Id = studentProfile.Id,
                                UserAccountId = studentProfile.UserAccountId,
                                FirstName = studentProfile.FirstName,
                                LastName = studentProfile.LastName,
                                MiddleName = studentProfile.MiddleName,
                                Age = studentProfile.Age,
                                Gender = studentProfile.Gender,
                                School = studentProfile.School,
                                TeacherName = studentProfile.TeacherName,
                                Level = studentProfile.Level,
                                StudentNumber = studentProfile.StudentNumber,
                                Section = studentProfile.Section,
                            }).ToList();
                }
                
                return View(list);
            }
                
        }

        // GET: StudentProfile/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            StudentProfile studentProfile = db.StudentProfiles.Find(id);
            if (studentProfile == null)
            {
                return HttpNotFound();
            }
            return View(studentProfile);
        }

        // GET: StudentProfile/Create
        public ActionResult Create()
        {
            ViewBag.UserAccountId = new SelectList(db.UserAccounts, "Id", "UserName");
            return View();
        }

        // POST: StudentProfile/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,StudentNumber,FirstName,LastName,MiddleName,Age,Gender,TeacherName,School,Level,Section,Weight,Height,BodyType,UserAccountId")] StudentProfile studentProfile)
        {
            if (ModelState.IsValid)
            {
                db.StudentProfiles.Add(studentProfile);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.UserAccountId = new SelectList(db.UserAccounts, "Id", "UserName", studentProfile.UserAccountId);
            return View(studentProfile);
        }

        // GET: StudentProfile/Edit/5
        public ActionResult Edit()
        {
            var user = (UserSessionViewModel)Session["UserLogged"];

            if (user == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            using (var dbCon = new LMSDBContext())
            {
                var studentProfile = db.StudentProfiles
                    .Include(x => x.UserAccount)
                    .Where(x => x.UserAccountId == user.Id).FirstOrDefault();

                var profileViewModel = new StudentProfileViewModel();

                if (studentProfile != null)
                {
                    profileViewModel = new StudentProfileViewModel
                    {
                        Id = studentProfile.Id,
                        FirstName = studentProfile.FirstName,
                        LastName = studentProfile.LastName,
                        MiddleName = studentProfile.MiddleName,
                        School = studentProfile.School,
                        StudentNumber = studentProfile.StudentNumber,
                        BodyType = studentProfile.BodyType,
                        Weight = studentProfile.Weight,
                        Height = studentProfile.Height,
                        TeacherName = studentProfile.TeacherName,
                        Gender = studentProfile.Gender,
                        Section = studentProfile.Section,
                        Age = studentProfile.Age,
                        Level = studentProfile.Level
                    };
                }
                
                return View(profileViewModel);
            }            
        }

        // POST: StudentProfile/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,StudentNumber,FirstName,LastName,MiddleName,Age,Gender,TeacherName,School,Level,Section,Weight,Height,BodyType,UserAccountId")] StudentProfile studentProfile)
        {
            if (ModelState.IsValid)
            {
                db.Entry(studentProfile).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.UserAccountId = new SelectList(db.UserAccounts, "Id", "UserName", studentProfile.UserAccountId);
            return View(studentProfile);
        }

        // GET: StudentProfile/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            StudentProfile studentProfile = db.StudentProfiles.Find(id);
            if (studentProfile == null)
            {
                return HttpNotFound();
            }
            return View(studentProfile);
        }

        // POST: StudentProfile/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            StudentProfile studentProfile = db.StudentProfiles.Find(id);
            db.StudentProfiles.Remove(studentProfile);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public ActionResult ScoreCard(int? id)
        {
            using (var dbCon = new LMSDBContext())
            {
                if (id == null || id == 0)
                {
                    var user = (UserSessionViewModel)Session["UserLogged"];
                    var student = dbCon.UserAccounts.Include(x => x.Scores).Include(x => x.StudentProfile).Where(x => x.Id == user.Id).FirstOrDefault();
                    var vm = new StudentScoreDashBoardViewModel();
                    if (student != null)
                    {

                        vm.StudentName = user.Name;

                        if (student.StudentProfile.Any(x => !string.IsNullOrEmpty(x.BodyType)))
                        {
                            vm.Height = student.StudentProfile.FirstOrDefault().Height;
                            vm.Weight = student.StudentProfile.FirstOrDefault().Weight;
                            vm.BMIInterpretation = student.StudentProfile.FirstOrDefault().BodyType;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Stork Balance Stand Test"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Stork Balance Stand Test").FirstOrDefault();
                            vm.BalanceLeft = score.BalanceLeft;
                            vm.BalanceRight = score.BalanceRight;
                            vm.BalanceInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "3-Minute Step Test"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "3-Minute Step Test").FirstOrDefault();
                            vm.BeforeHearthRate = score.BeforeHearthRate;
                            vm.AfterHearthRate = score.AfterHearthRate;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Juggling"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Juggling").FirstOrDefault();
                            vm.JugglingHits = score.JugglingHits;
                            vm.JugglingInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Zipper Test"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Zipper Test").FirstOrDefault();
                            vm.ZipperGap = score.ZipperGap;
                            vm.ZipperInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Sit and Reach"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Sit and Reach").FirstOrDefault();
                            vm.SitAndReachFirstTry = score.SitAndReachFirstTry;
                            vm.SitAndReachSecondTry = score.SitAndReachSecondTry;
                            vm.SitAndReachBestScore = score.SitAndReachFirstTry >= score.SitAndReachSecondTry ? score.SitAndReachFirstTry : score.SitAndReachSecondTry;
                            vm.SitAndReachInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Standing Long Jump"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Standing Long Jump").FirstOrDefault();
                            vm.LongJumpFirstTry = score.LongJumpFirstTry;
                            vm.LongJumpSecondTry = score.LongJumpSecondTry;
                            vm.LongJumpInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Stick Drop Test"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Stick Drop Test").FirstOrDefault();
                            vm.StickDrop1 = score.StickDrop1;
                            vm.StickDrop2 = score.StickDrop2;
                            vm.StickDrop3 = score.StickDrop3;
                            vm.StickDropInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Push up"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Push up").FirstOrDefault();
                            vm.NumberOfPushUps = score.NumberOfPushUps;
                            vm.PushUpInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Basic Plank"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Basic Plank").FirstOrDefault();
                            vm.PlankTime = score.PlankTime;
                            vm.PlankInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "40-Meter Sprint"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "40-Meter Sprint").FirstOrDefault();
                            vm.SprintTime = score.SprintTime;
                            vm.SprintInterpretation = score.Interpretation;
                        }

                    }

                    return View(vm);
                }
                else
                {

                    var student = dbCon.UserAccounts.Include(x => x.Scores).Include(x => x.StudentProfile).Where(x => x.Id == id).FirstOrDefault();
                    var vm = new StudentScoreDashBoardViewModel();

                    if (student != null)
                    {
                        vm.StudentName = student.StudentProfile.FirstOrDefault().FirstName + " " + student.StudentProfile.FirstOrDefault().LastName;

                        if (student.StudentProfile.Any(x => !string.IsNullOrEmpty(x.BodyType)))
                        {
                            vm.Height = student.StudentProfile.FirstOrDefault().Height;
                            vm.Weight = student.StudentProfile.FirstOrDefault().Weight;
                            vm.BMIInterpretation = student.StudentProfile.FirstOrDefault().BodyType;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Stork Balance Stand Test"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Stork Balance Stand Test").FirstOrDefault();
                            vm.BalanceLeft = score.BalanceLeft;
                            vm.BalanceRight = score.BalanceRight;
                            vm.BalanceInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "3-Minute Step Test"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "3-Minute Step Test").FirstOrDefault();
                            vm.BeforeHearthRate = score.BeforeHearthRate;
                            vm.AfterHearthRate = score.AfterHearthRate;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Juggling"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Juggling").FirstOrDefault();
                            vm.JugglingHits = score.JugglingHits;
                            vm.JugglingInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Zipper Test"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Zipper Test").FirstOrDefault();
                            vm.ZipperGap = score.ZipperGap;
                            vm.ZipperInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Sit and Reach"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Sit and Reach").FirstOrDefault();
                            vm.SitAndReachFirstTry = score.SitAndReachFirstTry;
                            vm.SitAndReachSecondTry = score.SitAndReachSecondTry;
                            vm.SitAndReachBestScore = score.SitAndReachFirstTry >= score.SitAndReachSecondTry ? score.SitAndReachFirstTry : score.SitAndReachSecondTry;
                            vm.SitAndReachInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Standing Long Jump"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Standing Long Jump").FirstOrDefault();
                            vm.LongJumpFirstTry = score.LongJumpFirstTry;
                            vm.LongJumpSecondTry = score.LongJumpSecondTry;
                            vm.LongJumpInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Stick Drop Test"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Stick Drop Test").FirstOrDefault();
                            vm.StickDrop1 = score.StickDrop1;
                            vm.StickDrop2 = score.StickDrop2;
                            vm.StickDrop3 = score.StickDrop3;
                            vm.StickDropInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Push up"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Push up").FirstOrDefault();
                            vm.NumberOfPushUps = score.NumberOfPushUps;
                            vm.PushUpInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "Basic Plank"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "Basic Plank").FirstOrDefault();
                            vm.PlankTime = score.PlankTime;
                            vm.PlankInterpretation = score.Interpretation;
                        }

                        if (student.Scores.Any(x => x.TestTitle == "40-Meter Sprint"))
                        {
                            var score = student.Scores.Where(x => x.TestTitle == "40-Meter Sprint").FirstOrDefault();
                            vm.SprintTime = score.SprintTime;
                            vm.SprintInterpretation = score.Interpretation;
                        }

                    }

                    return View(vm);
                }
            }
        }
    }
}
