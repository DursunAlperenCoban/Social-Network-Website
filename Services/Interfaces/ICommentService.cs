using ParlanceNet.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ParlanceNet.Services.Interfaces
{
    public interface ICommentService
    {
        int addComment(int ownerId,int postId,string comment);
        ICollection<Comment> getCommentsByPostId(int postId);
    }
}
