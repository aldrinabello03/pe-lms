using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using PELMS.DAL;
using PELMS.Models;

namespace PELMS.Controllers
{
    public class TeacherProfileController : Controller
    {
        private LMSDBContext db = new LMSDBContext();

        // GET: TeacherProfile
        public ActionResult Index()
        {
            var teacherProfiles = db.TeacherProfiles.Include(t => t.UserAccount);
            return View(teacherProfiles.ToList());
        }

        // GET: TeacherProfile/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            TeacherProfile teacherProfile = db.TeacherProfiles.Find(id);
            if (teacherProfile == null)
            {
                return HttpNotFound();
            }
            return View(teacherProfile);
        }

        // GET: TeacherProfile/Create
        public ActionResult Create()
        {
            ViewBag.UserAccountId = new SelectList(db.UserAccounts, "Id", "UserName");
            return View();
        }

        // POST: TeacherProfile/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,EmployeeNumber,Title,FirstName,LastName,MiddleName,School,UserAccountId")] TeacherProfile teacherProfile)
        {
            if (ModelState.IsValid)
            {
                db.TeacherProfiles.Add(teacherProfile);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.UserAccountId = new SelectList(db.UserAccounts, "Id", "UserName", teacherProfile.UserAccountId);
            return View(teacherProfile);
        }

        // GET: TeacherProfile/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            TeacherProfile teacherProfile = db.TeacherProfiles.Find(id);
            if (teacherProfile == null)
            {
                return HttpNotFound();
            }
            ViewBag.UserAccountId = new SelectList(db.UserAccounts, "Id", "UserName", teacherProfile.UserAccountId);
            return View(teacherProfile);
        }

        // POST: TeacherProfile/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,EmployeeNumber,Title,FirstName,LastName,MiddleName,School,UserAccountId")] TeacherProfile teacherProfile)
        {
            if (ModelState.IsValid)
            {
                db.Entry(teacherProfile).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.UserAccountId = new SelectList(db.UserAccounts, "Id", "UserName", teacherProfile.UserAccountId);
            return View(teacherProfile);
        }

        // GET: TeacherProfile/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            TeacherProfile teacherProfile = db.TeacherProfiles.Find(id);
            if (teacherProfile == null)
            {
                return HttpNotFound();
            }
            return View(teacherProfile);
        }

        // POST: TeacherProfile/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            TeacherProfile teacherProfile = db.TeacherProfiles.Find(id);
            db.TeacherProfiles.Remove(teacherProfile);
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
