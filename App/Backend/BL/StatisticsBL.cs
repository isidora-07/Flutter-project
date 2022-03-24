using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class StatisticsBL : IStatisticsBL
    {
        private readonly IStatisticsDAL _iStatisticsDAL;

        public StatisticsBL(IStatisticsDAL iStatisticsDAL)
        {
            _iStatisticsDAL = iStatisticsDAL;
        }

        public StatisticsViewModel basicStatistics()
        {
            return _iStatisticsDAL.basicStatistics();
        }

        public List<int> monthlyUsers()
        {
            return _iStatisticsDAL.monthlyUsers();
        }

        public List<int> postsByType()
        {
            return _iStatisticsDAL.postsByType();
        }

        public List<UserViewModel> top10Users()
        {
            return _iStatisticsDAL.top10Users();
        }
    }
}
