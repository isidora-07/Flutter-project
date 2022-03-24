using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IReportCommentDAL
    {
        List<ReportComment> getAllReportedComment();
        ReportComment insertReportComment(ReportComment report);
    }
}
