using ParlanceNet.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace ParlanceNet.Services.Interfaces
{
    interface IChatService
    {
        Chat getChatById(int chatId);
        int getChatIdByUsers(int user1, int user2);
        int createChat(int user1, int user2);

    }
}
