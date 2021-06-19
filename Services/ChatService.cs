using ParlanceNet.Models;
using ParlanceNet.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ParlanceNet.Services
{
    public class ChatService : IChatService
    {

        ParlanceDBEntities _context;
        public ChatService(ParlanceDBEntities context)
        {
            _context = context;
        }

        public int createChat(int user1, int user2)
        {
            Chat chat = new Chat
            {
                CreatedOn = DateTime.Now,
                IsDeleted = false,
                UserOne = user1,
                UserTwo = user2,

            };
            _context.Chat.Add(chat);
            return _context.SaveChanges();
        }

        public Chat getChatById(int chatId)
        {
            return null;
        }

        public int getChatIdByUsers(int user1, int user2)
        {
            Chat chat1 = _context.Chat.Where(c => c.UserOne == user1 && c.UserTwo == user2 && c.IsDeleted==false).FirstOrDefault();
            if (chat1 != null)
            {
                return chat1.ID;
            }
            else
            {
                Chat chat2 = _context.Chat.Where(c => c.UserOne == user2 && c.UserTwo == user1 && c.IsDeleted == false).FirstOrDefault();
                if (chat2 != null)
                {
                    return chat2.ID;
                }
                else
                    return 0;
            }

        }

    }
}
