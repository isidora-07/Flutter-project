using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class ReportUI : IReportUI
    {
        private readonly IReportBL _iReportBL;

        public ReportUI(IReportBL iReportBL)
        {
            _iReportBL = iReportBL;
        }

        public List<User> getAllReportedUser()
        {
            return _iReportBL.getAllReportedUser();
        }

        public List<Report> getAllUserWhoHaveReportedUser(long id)
        {
            return _iReportBL.getAllUserWhoHaveReportedUser(id);
        }

        public List<User> getReportedUsersByCityId(long cityId)
        {
            return _iReportBL.getReportedUsersByCityId(cityId);
        }

        public Report insertReport(Report report)
        {
            return _iReportBL.insertReport(report);
        }
    }
}
