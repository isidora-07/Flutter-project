using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IReportDAL
    {
        List<User> getAllReportedUser(); 
        List<Report> getAllUserWhoHaveReportedUser(long id);
        Report insertReport(Report report);
        List<User> getReportedUsersByCityId(long cityId);
    }
}
