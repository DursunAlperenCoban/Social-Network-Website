using ParlanceNet.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ParlanceNet.Services.Interfaces
{
    public interface IUserService
    {
        User getUserById(int userId);
        User getUserByUsername(string Username);
        ICollection<User> getUserFriends(int userId);
        ICollection<User> getEgoFriends(int userId);
        ICollection<User> getReqFriendNot(int userId);
        ICollection<User> getSendReqList(int sessionId);
        ICollection<Post> getLinkedPostsUserById(int sessionId);
        int addFriendReq(int friendId,int sessionId);
        int likePost(int postId, int sessionId);
        ICollection<Message> getMsgChatById(int friendId,int sessionId);
        User getUserByEmail(string email);
        int addUser(User user);
        int addFriend(int userId,int sessionId);
        int updateUser(User user);
        int deleteUser(User user);
        int UpdateUser(User user);
    }
}
