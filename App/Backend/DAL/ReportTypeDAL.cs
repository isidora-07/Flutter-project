using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class ReportTypeDAL :IReportTypeDAL
    {
        private readonly AppDbContext _context;

        public ReportTypeDAL(AppDbContext context)
        {
            _context = context;
        }

        public List<ReportType> getAllReportTypes()
        {
            return _context.reportType.ToList();
        }

        public ReportType getByID(long id)
        {
            return _context.reportType.Where(x => x.id == id).FirstOrDefault();
        }
    }
}
