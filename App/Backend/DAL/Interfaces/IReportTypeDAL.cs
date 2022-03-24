using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IReportTypeDAL
    {
        List<ReportType> getAllReportTypes();
        ReportType getByID(long id);
    }
}
