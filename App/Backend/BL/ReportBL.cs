using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class ReportBL : IReportBL
    {
        private readonly IReportDAL _iReportDAL;

        public ReportBL(IReportDAL iReportDAL)
        {
            _iReportDAL = iReportDAL;
        }

        public List<User> getAllReportedUser()
        {
            return _iReportDAL.getAllReportedUser();
        }

        public List<Report> getAllUserWhoHaveReportedUser(long id)
        {
            return _iReportDAL.getAllUserWhoHaveReportedUser(id);
        }

        public List<User> getReportedUsersByCityId(long cityId)
        {
            return _iReportDAL.getReportedUsersByCityId(cityId);
        }

        public Report insertReport(Report report)
        {
            return _iReportDAL.insertReport(report);
        }
    }
}
