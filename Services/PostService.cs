using ParlanceNet.Models;
using ParlanceNet.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ParlanceNet.Services
{
    public class PostService : IPostService
    {
        private ParlanceDBEntities _context = new ParlanceDBEntities();


        public int addPost(Post post, int sessionId)
        {
            User user = _context.User.Where(u => u.ID == sessionId).FirstOrDefault();
            Post newPost = new Post
            {
                CreatedOn = DateTime.Now,
                Text = post.Text,
                IsDeleted = false,
            };

            user.Post.Add(newPost);
            if (_context.SaveChanges() > 0)
            {
                Post lastPost = user.Post.Last();
               _context.SaveChanges();
                return lastPost.ID;
            }
            else
                return 0;

        }

    
        public int addPost(Post post,int sessionId,string ext)
        {
            User user = _context.User.Where(u => u.ID == sessionId).FirstOrDefault();
            Post newPost = new Post
            {
                CreatedOn = DateTime.Now,
                Text = post.Text,
                IsDeleted = false,
            };

            user.Post.Add(newPost);

            if (_context.SaveChanges() > 0)
            {
                Post lastPost = user.Post.Last();
                string imgName = "post" + lastPost.ID + "-" + user.Username + ext;
                lastPost.PostImgPath=imgName;
                _context.SaveChanges();
                return lastPost.ID;
            }
            else
                return 0;

        }

        public ICollection<User> getLikeUsersPostById(int postId)
        {
            Post post = _context.Post.Where(p => p.ID == postId).FirstOrDefault();
            //add ParlanceNet.model.like  public virtual User Owner { get; set; } model need this status  
            return post.Like.Where(l=>l.IsDeleted==false).Select(l => l.User).ToList();//change l.owner to l.user
        }
    }
}
