using System;
using System.Linq;
using System.Web.Mvc;
using System.Web.Security;
using ParlanceNet.Models;
namespace ParlanceNet.Controllers
{
    public class AccountController : Controller
    {
        private ParlanceDBEntities db = new ParlanceDBEntities();
        [AllowAnonymous]
        [HttpGet]
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "None")]
        public ActionResult Login()
        {
            return View("Login");
        }
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]

        public ActionResult Register(RegisterViewModel model)
        {
            if (ModelState.IsValid)
            {
                if (db.User.Where(s => s.Email == model.Email).FirstOrDefault() != null)
                {
                    ViewBag.Error="Email is already been taken.";
                    return View("Login");
                }
                else
                {
                    Random rnd = new Random();
                    var username = InnerTrim(model.Fullname);
                    while(db.User.Where(s=>s.Username==username).FirstOrDefault()!=null)
                    {
                        int rnds = rnd.Next(1900, 2060);
                        username = username + rnds.ToString();
                    }
                    User user = new User();
                    user.Username = username;
                    user.BirthDate = (DateTime)model.Birthdate;
                    user.Fullname = model.Fullname;
                    user.Email = model.Email;
                    user.Password = model.Password;
                    user.Gender = model.Gender;
                    user.CreatedOn = DateTime.Now;
                    user.EditedOn=DateTime.Now;
                    user.IsDeleted = false;
                    user.RoleId = 1;
                    db.User.Add(user);
                    db.SaveChanges();
                    ViewBag.Message="Created Account Successful.";//new
                    return View("Login");
                }
            }
            else
                return View("Login");

        }



        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginViewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = db.User.Where(s => s.Email == model.Email).FirstOrDefault();
                if (db.User.Where(s => s.IsDeleted == false && s.Email == user.Email).FirstOrDefault() != null) //new
                {
                    if (db.User.Where(s => s.Password == model.Password && s.Email == model.Email).FirstOrDefault() !=
                        null)
                    {
                        Session.Add("Username", user.Username);
                        Session.Add("UserId", user.ID);

                        FormsAuthentication.SetAuthCookie(user.ID.ToString(), false);

                        return RedirectToAction("Index", "Home");
                    }

                    ViewBag.LoginError = "Incorrect user name or password.";
                    return View("Login");
                }

                ViewBag.LoginError = "Your Account is Suspended.";
                return View("Login");
            }
            else
                return View("Login");
        }
        public static string InnerTrim(string input)//Trim empty space from string
        {
            return input.Trim().Replace(" ", string.Empty);
        }


        [Authorize]
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            Session.Abandon();//new
            return RedirectToAction("Login");
        }
        
    }

}
