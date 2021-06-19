using ParlanceNet.Models;
using ParlanceNet.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ParlanceNet.Services
{
    public class UserService
    {
        private ParlanceDBEntities _context = new ParlanceDBEntities();
        

        public int addFriend(int userId,int sessionId)
        {
            User session = _context.User.Where(u=>u.ID == sessionId).FirstOrDefault();
            User sender = _context.User.Where(u=>u.ID == userId).FirstOrDefault();

            Friendship friendship = new FriendshipService(_context).getFriendShip(sender.ID,session.ID);
            friendship.IsFriend = true;
            //_context.Update(friendship);

            return _context.SaveChanges();
        }

        public int addFriendReq(int friendId, int sessionId)
        {
            User session = _context.User.Where(u => u.ID == sessionId).FirstOrDefault();
            User friend = _context.User.Where(u => u.ID == friendId).FirstOrDefault();
            if(new FriendshipService(_context).getAnyFriendship(friendId, sessionId)==null)
            {
                if (session != null && friend != null)
                {
                    Friendship friendShip = new Friendship
                    {
                        CreatedOn = DateTime.Now,
                        IsDeleted = false,
                        EditedOn = DateTime.Now,
                        IsFriend = false,
                        ReceipentID = friend.ID,
                        SenderID = session.ID
                    };
                    _context.Friendship.Add(friendShip);

                    return _context.SaveChanges();
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                Friendship friendship = new FriendshipService(_context).getAnyFriendship(friendId, sessionId);
                friendship.IsDeleted = false;
                friendship.EditedOn = DateTime.Now;
                //_context.Update(friendship);

                return _context.SaveChanges();
            }
        
        }

        public int addUser(User user)
        {
            _context.User.Add(user);
            return _context.SaveChanges();
        }

        public int deleteUser(User user)
        {
            throw new NotImplementedException();
        }

        public ICollection<User> getEgoFriends(int userId)
        {
            User session = _context.User.Where(u => u.ID == userId && u.IsDeleted==false).FirstOrDefault();
            ICollection<User> egoFriends = new List<User>();
            ICollection<User> friends = getUserFriendsAndReq(userId);
            ICollection<User> allUser = _context.User.ToList();
            foreach (var user in allUser)
            {
                if (friends.Contains(user)==false && user!=session )
                {
                    egoFriends.Add(user);
                }
            }
            return egoFriends.Take(3).ToList();      
        }

        public ICollection<Post> getLinkedPostsUserById(int sessionId)
        {
            ICollection<Post> linkedPosts = new List<Post>();
            User user = _context.User.Where(u=>u.ID==sessionId).FirstOrDefault();
            foreach (var friend in getUserFriends(sessionId))
            {
                foreach (var post in friend.Post)
                {
                    linkedPosts.Add(post);
                }
            }
            foreach (var post in user.Post)
            {
                linkedPosts.Add(post);
            }
            return linkedPosts.OrderByDescending(p=>p.CreatedOn).ToList();
        }

        public ICollection<Message> getMsgChatById(int friendId,int sessionId)
        {
            ICollection<Message> messages = new List<Message>();

            Chat chat = _context.Chat.Where(c => (c.UserOne == friendId && c.UserTwo == sessionId) || (c.UserOne == sessionId && c.UserTwo == friendId)).FirstOrDefault();
            if (chat != null)
            {
                messages = _context.Message.Where(m => m.ChatID == chat.ID).ToList();
            }

            return messages;
        }

        public ICollection<User> getReqFriendNot(int sessionId)
        {
            ICollection<User> notifications = new List<User>();
            User user = _context.User.Where(u => u.ID == sessionId).FirstOrDefault();
            ICollection<int> senderId = _context.Friendship.Where(f => f.ReceipentID == sessionId && f.IsDeleted == false && f.IsFriend == false).Select(u => u.SenderID).ToList();
            foreach (var id in senderId)
            {
                notifications.Add(_context.User.Where(u => u.ID == id).FirstOrDefault());
            }

            return notifications;
        }

        public ICollection<User> getSendReqList(int sessionId)
        {
            ICollection<User> sendReqList = new List<User>();
            ICollection<int> receiverList = _context.Friendship.Where(f => f.SenderID == sessionId && f.IsFriend==false && f.IsDeleted==false).Select(f => f.ReceipentID).ToList();
            foreach (var receiverId in receiverList)
            {
                sendReqList.Add(_context.User.Where(u=>u.ID==receiverId).FirstOrDefault());
            }

            return sendReqList;
        }

        public User getUserByEmail(string email)
        {
            User user = _context.User.Where(u=>u.Email==email).FirstOrDefault();

            return user;
        }

        public User getUserById(int userId)
        {
            User user = _context.User.Where(u => u.ID == userId&&u.IsDeleted==false).FirstOrDefault();
            return user;

        }

        public User getUserByUsername(string username)
        {
            User user = _context.User.Where(u => u.Username == username&&u.IsDeleted==false).FirstOrDefault();

            return user;
        }

        public ICollection<User> getUserFriends(int userId)
        {
            ICollection<User> friends = new List<User>();

            ICollection<int> receipentId = _context.Friendship.Where(f => f.SenderID == userId && f.IsDeleted==false && f.IsFriend==true&&f.User.IsDeleted==false).Select(u => u.ReceipentID).ToList();
            ICollection<int> senderId = _context.Friendship.Where(f => f.ReceipentID == userId && f.IsDeleted == false && f.IsFriend == true&&f.User.IsDeleted==false).Select(u => u.SenderID).ToList();
            foreach (var recid in receipentId)
            {
                friends.Add(_context.User.Where(u => u.ID == recid).FirstOrDefault());
            }
            foreach (var senderid in senderId)
            {
                friends.Add(_context.User.Where(u => u.ID == senderid).FirstOrDefault());
            }

            return friends;
        }

        public ICollection<User> getUserFriendsAndReq(int userId)
        {
            List<User> friends = new List<User>();

            List<int> receipentId = _context.Friendship.Where(f => f.SenderID == userId && f.IsDeleted == false).Select(u => u.ReceipentID).ToList();
            List<int> senderId = _context.Friendship.Where(f => f.ReceipentID == userId && f.IsDeleted == false).Select(u => u.SenderID).ToList();
            foreach (var recid in receipentId)
            {
                friends.Add(_context.User.Where(u => u.ID == recid).FirstOrDefault());
            }
            foreach (var senderid in senderId)
            {
                friends.Add(_context.User.Where(u => u.ID == senderid).FirstOrDefault());
            }

            return friends;
        }

        public ICollection<User> getUserOnlyReqFriends(int userId)
        {
            ICollection<User> friends = new List<User>();

            //ICollection<int> receipentId = _context.Friendship.Where(f => f.SenderID == userId && f.IsDeleted == false && f.IsFriend == false).Select(u => u.ReceipentID).ToList();
            ICollection<int> senderId = _context.Friendship.Where(f => f.ReceipentID == userId && f.IsDeleted == false && f.IsFriend == false).Select(u => u.SenderID).ToList();
            //foreach (var recid in receipentId)
            //{
            //    friends.Add(_context.User.Where(u => u.ID == recid).FirstOrDefault());
            //}
            foreach (var senderid in senderId)
            {
                friends.Add(_context.User.Where(u => u.ID == senderid).FirstOrDefault());
            }

            return friends;
        }

        public int likePost(int postId, int sessionId)
        {
            if (_context.Like.Any(l => l.PostID == postId && l.OwnerID == sessionId))
            {

                Like like = _context.Like.Where(l => l.PostID == postId && l.OwnerID == sessionId).FirstOrDefault();
                if (like.IsDeleted == false)
                {
                    like.IsDeleted = true;
                    return _context.SaveChanges();
                }
                else
                {
                    like.IsDeleted = false;
                    return _context.SaveChanges();
                }
            }
            else
            {
                User user = _context.User.Where(u => u.ID == sessionId).FirstOrDefault();
                Like like = new Like
                {
                    CreatedOn = DateTime.Now,
                    EditedOn=DateTime.Now,
                    Post = _context.Post.Where(p => p.ID == postId).FirstOrDefault(),
                    PostID = postId,
                    IsDeleted = false
                };
                user.Like.Add(like);
                return _context.SaveChanges();
            }     
        }

        public int updateUser(User user)
        {
            throw new NotImplementedException();
        }

        public int UpdateUser(User user)
        {
            User newUser = new User()
            {
                AvatarImgPath = user.AvatarImgPath,
                BgImgPath = user.BgImgPath,
                BirthDate = DateTime.Now,
                CreatedOn = DateTime.Now,
                Fullname = user.Fullname,
                Gender = user.Gender,
                EditedOn = DateTime.Now,
                Email = user.Email,
                IsDeleted = user.IsDeleted,
                Password = user.Password,
                Tel = user.Tel,
                Username = user.Username
            };

            //_context.Update(user);

            return _context.SaveChanges();
        }
    }
}
