using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IReportCommentBL
    {
        List<ReportComment> getAllReportedComment();
        ReportComment insertReportComment(ReportComment report);
    }
}
