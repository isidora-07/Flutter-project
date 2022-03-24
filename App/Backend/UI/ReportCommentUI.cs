using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class ReportCommentUI : IReportCommentUI
    {
        private readonly IReportCommentBL _iReportCommentBL;

        public ReportCommentUI(IReportCommentBL iReportCommentBL)
        {
            _iReportCommentBL = iReportCommentBL;
        }

        public List<ReportComment> getAllReportedComment()
        {
            return _iReportCommentBL.getAllReportedComment();
        }

        public ReportComment insertReportComment(ReportComment report)
        {
            return _iReportCommentBL.insertReportComment(report);
        }
    }
}
