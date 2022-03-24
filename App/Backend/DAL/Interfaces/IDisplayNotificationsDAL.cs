using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IDisplayNotificationsDAL
    {
        List<NotificationViewModel> solutionsForNotification(long userId);
    }
}
