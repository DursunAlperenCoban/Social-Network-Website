using ParlanceNet.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ParlanceNet.Services.Interfaces
{
    public interface IPostService
    {
        int addPost(Post post, int sessionId);
        int addPost(Post post,int sessionId,string ext);
        ICollection<User> getLikeUsersPostById(int postId);
    }
}
