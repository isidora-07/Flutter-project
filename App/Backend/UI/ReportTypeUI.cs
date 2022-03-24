using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class ReportTypeUI :IReportTypeUI
    {
        private readonly IReportTypeBL _iReportTypeBL;

        public ReportTypeUI(IReportTypeBL iReportTypeBL)
        {
            _iReportTypeBL = iReportTypeBL;
        }

        public List<ReportType> getAllReportTypes()
        {
            return _iReportTypeBL.getAllReportTypes();
        }

        public ReportType getByID(long id)
        {
            return _iReportTypeBL.getByID(id);
        }
    }
}
