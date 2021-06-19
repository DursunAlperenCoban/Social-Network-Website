using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ParlanceNet.Models.ViewModels
{
    public class GlobalViewModel
    {
        public User session { get; set; }
        public User user { get; set; }
        public ICollection<User> friendReqNotifications { get; set; } = new List<User>();
        public ICollection<User> friends { get; set; } = new List<User>();
        public ICollection<User> egoFriends { get; set; } = new List<User>();
        public ICollection<User> sendReqList { get; set; } = new List<User>();
        public ICollection<Post> allPost { get; set; } = new List<Post>();
        public string partialKey { get; set; }
    }
}