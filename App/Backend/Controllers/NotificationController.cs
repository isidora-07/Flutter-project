using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private readonly IDisplayNotificationsUI _iDisplayNotificationsUI;

        public NotificationController(IDisplayNotificationsUI iDisplayNotificationsUI)
        {
            _iDisplayNotificationsUI = iDisplayNotificationsUI;
        }

        [Authorize]
        [HttpGet("userId={userId}")]
        public IEnumerable<NotificationViewModel> SolvingForNotification(int userId)
        {
            return _iDisplayNotificationsUI.solutionsForNotification(userId);
        }
    }
}