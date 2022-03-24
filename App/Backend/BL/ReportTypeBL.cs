using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class ReportTypeBL : IReportTypeBL
    {
        private readonly IReportTypeDAL _iReportTypeDAL;

        public ReportTypeBL(IReportTypeDAL iReportTypeDAL)
        {
            _iReportTypeDAL = iReportTypeDAL;
        }

        public List<ReportType> getAllReportTypes()
        { 
            return _iReportTypeDAL.getAllReportTypes();
        }

        public ReportType getByID(long id)
        {
            return _iReportTypeDAL.getByID(id);
        }
    }
}
