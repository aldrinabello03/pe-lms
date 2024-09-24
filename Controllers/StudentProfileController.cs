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
            var studentProfiles = db.StudentProfiles.Include(s => s.UserAccount);
            return View(studentProfiles.ToList());
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
    }
}
