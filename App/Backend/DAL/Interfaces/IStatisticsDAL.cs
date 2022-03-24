using Backend.Models;
using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IStatisticsDAL
    {
        StatisticsViewModel basicStatistics();
        List<UserViewModel> top10Users();
        List<int> monthlyUsers();
        List<int> postsByType();
    }
}
