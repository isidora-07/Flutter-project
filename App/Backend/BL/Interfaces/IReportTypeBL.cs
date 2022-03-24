using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IReportTypeBL
    {
        List<ReportType> getAllReportTypes();
        ReportType getByID(long id);
    }
}
