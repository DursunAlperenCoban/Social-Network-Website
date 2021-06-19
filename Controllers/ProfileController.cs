using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ParlanceNet.Models;
using ParlanceNet.Models.ViewModels;
using ParlanceNet.Services;
namespace ParlanceNet.Controllers
{
    public class ProfileController : Controller
    {
        private UserService userService = new UserService();
        private ParlanceDBEntities db = new ParlanceDBEntities();
        [Authorize]
        
        public ActionResult Index(string username)
        {
            try
            {
                string sessionuser = Session["Username"].ToString();
                User session = db.User.Where(s => s.Username == sessionuser).FirstOrDefault();
                string sessionName = HttpContext.User.Identity.Name;
                User user = db.User.Where(s => s.Username == username).FirstOrDefault();
                if (user.IsDeleted == false)
                {
                    GlobalViewModel profileModel = new GlobalViewModel();
                    profileModel.session = session;
                    profileModel.user = user;
                    profileModel.friends = userService.getUserFriends(user.ID); //edited session.ıd to user.ıd
                    profileModel.partialKey = "_PartialTimeLine";
                    profileModel.friendReqNotifications = userService.getReqFriendNot(session.ID);
                    profileModel.sendReqList = userService.getSendReqList(session.ID);
                    if (sessionName == username)
                    {
                        profileModel.allPost = session.Post.Where(s => s.IsDeleted != true)
                            .OrderByDescending(s => s.CreatedOn).Select(s => s).ToList();
                    } //edited after uplaod Where(s => s.IsDeleted != true)
                    else
                        profileModel.allPost = user.Post.Where(s => s.IsDeleted != true)
                            .OrderByDescending(s => s.CreatedOn).Select(s => s).ToList();

                    //edited after uplaod Where(s => s.IsDeleted != true)
                    return View("Index", profileModel);
                }
                else{ return RedirectToAction("Index", "Home");}
            }
            catch (Exception a)
            {
                ViewBag.Error = "Session Timeout..";
                return RedirectToAction("Login", "Account");
            }

            return RedirectToAction("Index", "Home");
        }


        [HttpPost]
        public ActionResult SaveAvatar(HttpPostedFileBase photo)
        {
            bool state = false;
            try
            {
                string username = Session["Username"].ToString();
                var phextension = Path.GetExtension(photo.FileName);
                string photoName = "avatar-" + username + phextension;
                var path = Path.Combine(Server.MapPath("~/Content/images/avatars"), photoName);
                
                photo.SaveAs(path);

                User user = userService.getUserByUsername(username);
                user.AvatarImgPath = photoName;
                userService.UpdateUser(user);
                state = true;
            }
            catch(Exception e)
            {
                state = false;
            }

            return Json(state);
        }
        public ActionResult AcceptRequest(string userId)
        {
            var id = Int32.Parse(userId);
            var sesionid = int.Parse(Session["UserId"].ToString());
            User session = userService.getUserById(sesionid);
            if (userService.addFriend(id, session.ID) > 0)
            {
                return RedirectToAction("Index","Home");
            }
            else
            {
                return RedirectToAction("Index","Home");
            }
        }
    }
    }

