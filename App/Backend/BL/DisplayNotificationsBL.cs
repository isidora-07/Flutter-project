using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class DisplayNotificationsBL : IDisplayNotificationsBL
    {
        private readonly IDisplayNotificationsDAL _iDisplayNotificationsDAL;

        public DisplayNotificationsBL(IDisplayNotificationsDAL iDisplayNotificationsDAL)
        {
            _iDisplayNotificationsDAL = iDisplayNotificationsDAL;
        }

        public IEnumerable<NotificationViewModel> solutionsForNotification(long userId)
        {
            var list = _iDisplayNotificationsDAL.solutionsForNotification(userId).Take(50);
            return list;
        }
    }
}
