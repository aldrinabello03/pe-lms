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
using PELMS.Models.ViewModels;

namespace PELMS.Controllers
{
    public class UserAccountController : Controller
    {
        private LMSDBContext db = new LMSDBContext();

        // GET: UserAccounts
        public ActionResult Index()
        {
            return View(db.UserAccounts.ToList());
        }

        // GET: UserAccounts/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            UserAccount userAccount = db.UserAccounts.Find(id);
            if (userAccount == null)
            {
                return HttpNotFound();
            }
            return View(userAccount);
        }

        // GET: UserAccounts/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: UserAccounts/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(RegsitrationViewModel register)
        {
            if (ModelState.IsValid)
            {
                var userAccount = new UserAccount
                {
                    UserName = register.UserName,
                    Password = register.Password,
                    Role = register.Role
                };

                db.UserAccounts.Add(userAccount);
                db.SaveChanges();
                return RedirectToAction("Login");
            }

            return View(register);
        }

        // GET: UserAccounts/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            UserAccount userAccount = db.UserAccounts.Find(id);
            if (userAccount == null)
            {
                return HttpNotFound();
            }
            return View(userAccount);
        }

        // POST: UserAccounts/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,UserName,Password,Role")] UserAccount userAccount)
        {
            if (ModelState.IsValid)
            {
                db.Entry(userAccount).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(userAccount);
        }

        // GET: UserAccounts/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            UserAccount userAccount = db.UserAccounts.Find(id);
            if (userAccount == null)
            {
                return HttpNotFound();
            }
            return View(userAccount);
        }

        // POST: UserAccounts/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            UserAccount userAccount = db.UserAccounts.Find(id);
            db.UserAccounts.Remove(userAccount);
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

        public ActionResult Login()
        {
            var userLogged = (UserSessionViewModel)Session["UserLogged"];
            if (userLogged == null)
            {
                return View();
            }
            else
            {
                if (userLogged.Role == "Student")
                {
                    return Redirect("~/StudentProfile/ScoreCard");
                }
                else if (userLogged.Role == "Teacher")
                {
                    return Redirect("~/StudentProfile/Index");
                }
                else
                {
                    return Redirect("~/Home/About");
                }
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginViewModel login)
        {
            
            if (ModelState.IsValid)
            {
                using (var dbCon = new LMSDBContext())
                {
                    var user = dbCon.UserAccounts
                        .Where(x => x.UserName == login.UserName && x.Password == login.Password)
                        .FirstOrDefault();

                    if (user == null)
                    {
                        Session["UserLogged"] = null;
                        Session["UserLoggedName"] = "";
                        Session["Agreed"] = false;

                        return RedirectToAction("Login");
                    }
                    else
                    {
                        string name = user.UserName;
                        int age = 0;
                        int profileId = 0;

                        if (user.Role == "Student")
                        {
                            var studentProfile = dbCon.StudentProfiles.Where(x => x.UserAccountId == user.Id).FirstOrDefault();
                            if (studentProfile != null)
                            {
                                age = studentProfile.Age;
                                name = studentProfile.FirstName + " " + studentProfile.LastName;
                                profileId = studentProfile.Id;
                            }
                        }
                        else if (user.Role == "Teacher")
                        {
                            var teaherProfile = dbCon.TeacherProfiles.Where(x => x.UserAccountId == user.Id).FirstOrDefault();
                            if (teaherProfile != null)
                            {
                                name = teaherProfile.FirstName + " " + teaherProfile.LastName;
                                profileId = teaherProfile.Id;
                            }
                        }

                        var userSession = new UserSessionViewModel
                        {
                            Id = user.Id,
                            UserName = user.UserName,
                            Name = name,
                            Role = user.Role,
                            Age = age,
                            ProfileId = profileId,
                        };

                        Session["UserLogged"] = userSession;
                        Session["UserLoggedName"] = userSession.Name;
                        Session["Agreed"] = false;

                        //return Redirect("~/Home/DataPrivacyConsent");

                        if (userSession.Name == userSession.UserName)
                        {
                            if (userSession.Role == "Student")
                                return Redirect("~/StudentProfile/Edit");
                            else if (userSession.Role == "Teacher")
                                return Redirect("~/TeacherProfile/Edit");
                        }
                        else
                        {
                            if (userSession.Role == "Student")
                                return Redirect("~/StudentProfile/ScoreCard");
                            else if (userSession.Role == "Teacher")
                                return Redirect("~/StudentProfile/Index");
                        }
                    }
                }
            }

            return View(login);
        }

        [HttpPost]
        public ActionResult Proceed()
        {
            var userSession = (UserSessionViewModel)Session["UserLogged"];
            var name = Session["UserLoggedName"].ToString();
            var agreed = (bool)Session["Agreed"];

            if (userSession.Name == userSession.UserName)
            {
                if (userSession.Role == "Student")
                    return Redirect("~/StudentProfile/Edit");
                else if (userSession.Role == "Teacher")
                    return Redirect("~/TeacherProfile/Edit");
            }
            else
            {
                if (userSession.Role == "Student")
                    return Redirect("~/StudentProfile/ScoreCard");
                else if (userSession.Role == "Teacher")
                    return Redirect("~/StudentProfile/Index");
            }

            return RedirectToAction("Login");
        }

        [HttpPost]
        public ActionResult Exit()
        {
            Session["UserLogged"] = null;
            Session["UserLoggedName"] = "";
            Session["Agreed"] = false;

            return RedirectToAction("Login");
        }
    }
}
