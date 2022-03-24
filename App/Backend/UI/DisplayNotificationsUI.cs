using Backend.BL.Interfaces;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class DisplayNotificationsUI : IDisplayNotificationsUI
    {
        private readonly IDisplayNotificationsBL _iDisplayNotificationsBL;

        public DisplayNotificationsUI(IDisplayNotificationsBL iDisplayNotificationsBL)
        {
            _iDisplayNotificationsBL = iDisplayNotificationsBL;
        }

        public IEnumerable<NotificationViewModel> solutionsForNotification(long userId)
        {
            return _iDisplayNotificationsBL.solutionsForNotification(userId);
        }
    }
}
