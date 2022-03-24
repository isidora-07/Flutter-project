using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class ChatHub : Hub
    {
        public void Send(string title, string body, int payload, int userId)
        {
            Clients.All.SendCoreAsync("OnNotification", new object[] { title, body, payload, userId });
        }

        public override Task OnConnectedAsync()
        {
            return base.OnConnectedAsync();
        }

    }
}
