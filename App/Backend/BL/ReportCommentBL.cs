using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class ReportCommentBL : IReportCommentBL
    {
        private readonly IReportCommentDAL _iReportCommentDAL;

        public ReportCommentBL(IReportCommentDAL iReportCommentDAL)
        {
            _iReportCommentDAL = iReportCommentDAL;
        }

        public List<ReportComment> getAllReportedComment()
        {
            return _iReportCommentDAL.getAllReportedComment();
        }

        public ReportComment insertReportComment(ReportComment report)
        {
            return _iReportCommentDAL.insertReportComment(report);
        }
    }
}
