using Backend.BL.Interfaces;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class StatisticsUI :IStatisticsUI
    {
        private readonly IStatisticsBL _iStatisticsBL;

        public StatisticsUI(IStatisticsBL iStatisticsBL)
        {
            _iStatisticsBL = iStatisticsBL;
        }

        public StatisticsViewModel basicStatistics()
        {
            return _iStatisticsBL.basicStatistics();
        }

        public List<int> monthlyUsers()
        {
            return _iStatisticsBL.monthlyUsers();
        }

        public List<int> postsByType()
        {
            return _iStatisticsBL.postsByType();
        }

        public List<UserViewModel> top10Users()
        {
            return _iStatisticsBL.top10Users();
        }
    }
}
