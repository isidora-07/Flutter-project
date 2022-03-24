using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class ReportCommentDAL : IReportCommentDAL
    {
        private readonly AppDbContext _context;

        public ReportCommentDAL(AppDbContext context)
        {
            _context = context;
        }

        public List<ReportComment> getAllReportedComment()
        {
            return _context.reportComment.Include(x => x.comment).ToList();
        }

        public ReportComment insertReportComment(ReportComment report)
        {
            ReportComment report1 = new ReportComment();
            ReportComment exist = _context.reportComment.Where(x => x.commentId == report.commentId && x.userId == report.userId).FirstOrDefault();
            report1.commentId = report.commentId;
            report1.userId = report.userId;
            report1.time = DateTime.Now;
            int number = _context.reportComment.Where(x => x.commentId == report.commentId).Count();
            if(number >= 10)
            {
                var comment = _context.comment.Where(x => x.id == report.commentId).FirstOrDefault();
              
                _context.comment.Remove(comment);
                _context.SaveChangesAsync();
                return null;
            }
            else if (report1 != null && exist == null)
            {
                _context.reportComment.Add(report1);
                _context.SaveChangesAsync();
                return report1;
            }
            else
            {
                return null;
            }
        }
    }
}
