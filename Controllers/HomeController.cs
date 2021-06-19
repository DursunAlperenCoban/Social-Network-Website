using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ParlanceNet.Models;
using ParlanceNet.Models.ViewModels;
using ParlanceNet.Services;
using ActionResult = System.Web.Mvc.ActionResult;


namespace ParlanceNet.Controllers
{
    public class HomeController : Controller
    {
        private PostService postService = new PostService();
        private UserService userService = new UserService();
        private CommentService commentService = new CommentService();
        private ParlanceDBEntities db = new ParlanceDBEntities();

        [Authorize]
        public ActionResult Index()
        {
            try
            {
                var name = Session["Username"];
                User user = db.User.Where(s => s.Username == name).FirstOrDefault();
                if (user != null)
                {
                    GlobalViewModel model = new GlobalViewModel();
                    model.session = user;
                    model.friends = userService.getUserFriends(user.ID);
                    model.friendReqNotifications = userService.getUserOnlyReqFriends(user.ID);
                    model.egoFriends = userService.getEgoFriends(user.ID);
                    model.allPost = db.Post.Where(d=>d.IsDeleted==false&&d.User.IsDeleted==false).Select(d=>d).OrderByDescending(s => s.CreatedOn).ToList();
                    return View(model);
                }
            }
            catch (Exception ex)
            {
                return RedirectToAction("Login", "Account");
            }
            return RedirectToAction("Login", "Account");
        }



        public ActionResult SharePost(string postText, HttpPostedFileBase postImg)
        {
            try
            {


                if (postText != " " || postImg != null)
                {
                    int sessionId = Int32.Parse(Session["UserId"].ToString());
                    string username = Session["Username"].ToString();

                    Post post = new Post();
                    post.Text = postText;
                    if (postImg != null)
                    {
                        var phextension = Path.GetExtension(postImg.FileName);
                        int postId = postService.addPost(post, sessionId, phextension);
                        if (postId > 0)
                        {
                            if (postImg != null)
                            {

                                string photoName = "post" + postId + "-" + username + phextension;
                                var path = Path.Combine(Server.MapPath("~/Content/images/posts"), photoName);
                                postImg.SaveAs(path);
                            }

                            return Json(new {result = "Your Post was sent"});
                        }
                    }

                    else
                    {
                        int postId = postService.addPost(post, sessionId);
                        return Json(new {result = "Your Post sent only text"});
                    }
                }

            }
            catch (Exception ex)
            {
                return Json(new {result = "Your Post was not sent"});
            }
            return Json(new { result = "Your Post was not sent" });
        }


        public ActionResult SendFriendRequest(int friendId)
        {
            try
            {
                int sessionId = Int32.Parse(Session["UserId"].ToString());
                string username = Session["Username"].ToString();

                User friend = userService.getUserById(friendId);
                if (friend != null)
                {
                    if (userService.addFriendReq(friendId, sessionId) > 0)
                    {
                        return Json(true);
                    }
                    else
                    {

                        return Json(false);
                    }
                }
                
            }
            catch(Exception ex)
            {
                ViewBag.Error = "Session Timeout..";
                return RedirectToAction("Login", "Account");
            }

            return Json(false);

        }

        //public IActionResult LikePost(int postId)
        //{
        //    int sessionId = Int32.Parse(HttpContext.Session.GetString("userId"));
        //    if (_userService.likePost(postId, sessionId) > 0)
        //    {
        //        var likeCount = _postService.getLikeUsersPostById(postId).Count;
        //        return Json(new { likeCount });
        //    }
        //    else
        //    {
        //        return Json(false);
        //    }
        //}

        public ActionResult SendComment(int postId, string comment)
        {
            try
            {
                int sessionId = Int32.Parse(Session["UserId"].ToString());

                if (commentService.addComment(sessionId, postId, comment) > 0)
                {
                    return PartialView("_PartialComment", commentService.getCommentsByPostId(postId));
                }

            }
            catch (Exception e)
            {
                ViewBag.Error = "Session Timeout..";
                return RedirectToAction("Login", "Account");

            }
            
            return View("Index");
            
        }

        public JsonResult GetSession()
        {
            int userId = Int32.Parse(HttpContext.Session["UserId"].ToString());

            return Json(userId);
        }



    }
}