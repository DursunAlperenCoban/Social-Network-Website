using ParlanceNet.Models;
using ParlanceNet.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ParlanceNet.Services
{
    public class CommentService : ICommentService
    {
        private ParlanceDBEntities _context = new ParlanceDBEntities();
       

        public int addComment(int ownerId, int postId, string comment)
        {
            User owner = _context.User.Where(u => u.ID == ownerId).FirstOrDefault();
            Post post = _context.Post.Where(p => p.ID == postId).FirstOrDefault();
            try
            {
                Comment newComment = new Comment
                {
                    CreatedOn = DateTime.Now,
                    Post = post,
                    PostID = post.ID,
                    IsDeleted = false,
                    ComImgPath = null,
                    Text = comment
                };
                owner.Comment.Add(newComment);
                return _context.SaveChanges();
            }
            catch (Exception ex)
            {
                return -1;
            }

            return 0;
        }

        public ICollection<Comment> getCommentsByPostId(int postId)
        {
            Post post = _context.Post.Where(p => p.ID == postId).FirstOrDefault();
            return post.Comment.Where(c=>c.IsDeleted==false).OrderByDescending(c => c.CreatedOn).Select(c=>c).ToList();  
        }
    }
}
