using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IDisplayNotificationsBL
    {
        IEnumerable<NotificationViewModel> solutionsForNotification(long userId);
    }
}
