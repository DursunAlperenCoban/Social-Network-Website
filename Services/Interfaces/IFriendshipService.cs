using ParlanceNet.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ParlanceNet.Services.Interfaces
{
    public interface IFriendshipService
    {
        Friendship getFriendShip(int senderId, int receipentId);
        int removeFriendShip(int frienId, int sessionId);
        int declineRequest(int senderId,int receipentId);
        Friendship getAnyFriendship(int userId, int sessionId);
        int removeSendRequest(int senderId, int receipentId);
    }
}
