using ParlanceNet.Models;
using ParlanceNet.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ParlanceNet.Services
{
    public class FriendshipService : IFriendshipService
    {

        ParlanceDBEntities _context;
        public FriendshipService(ParlanceDBEntities context)
        {
            _context = context;
        }

        public int declineRequest(int senderId, int receipentId)
        {
            Friendship friendship = _context.Friendship.Where(f => f.SenderID == senderId && f.ReceipentID == receipentId && f.IsDeleted == false && f.IsFriend == false).FirstOrDefault();
            friendship.IsFriend = false;
            friendship.IsDeleted = true;
            //_context.Update(friendship);
            return _context.SaveChanges();
        }

        public Friendship getFriendShip(int senderId, int receipentId)
        {
            Friendship friendship = _context.Friendship.Where(f => f.SenderID == senderId && f.ReceipentID == receipentId && f.IsDeleted == false).FirstOrDefault();
 
            return friendship;
        }

        public Friendship getAnyFriendship(int userId, int sessionId)
        {
            Friendship fOne = _context.Friendship.Where(f => f.SenderID == userId && f.ReceipentID == sessionId).FirstOrDefault();
            if (fOne != null)
            {
                return fOne;
            }
            else
            {
                Friendship fTwo = _context.Friendship.Where(f => f.SenderID == sessionId && f.ReceipentID == userId).FirstOrDefault();
                if (fTwo != null)
                {
                    return fTwo;
                }
                else return null;
            }
        }

        public int removeFriendShip(int frienId, int sessionId)
        {
            Friendship friendshipOne = _context.Friendship.Where(f => f.SenderID == frienId && f.ReceipentID == sessionId && f.IsDeleted==false && f.IsFriend==true).FirstOrDefault();
            if (friendshipOne == null)
            {
                Friendship friendshipTwo = _context.Friendship.Where(f => f.SenderID == sessionId && f.ReceipentID == frienId && f.IsDeleted == false && f.IsFriend==true).FirstOrDefault();
                friendshipTwo.IsDeleted = true;
                friendshipTwo.IsFriend = false;
                //_context.Update(friendshipTwo);
                return _context.SaveChanges();
            }
            else
            {
                friendshipOne.IsDeleted = true;
                friendshipOne.IsFriend = false;
                //_context.Update(friendshipOne);
                return _context.SaveChanges();
            }          
        }

        public int removeSendRequest(int senderId, int receipentId)
        {
            Friendship friendship = _context.Friendship.Where(f => f.SenderID == senderId && f.ReceipentID == receipentId && f.IsDeleted == false && f.IsFriend==false).FirstOrDefault();
            friendship.IsFriend = false;
            friendship.IsDeleted = true;
            //_context.Update(friendship);
            return _context.SaveChanges();
        }



    }
}
