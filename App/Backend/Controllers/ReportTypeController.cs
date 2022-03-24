using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReportTypeController : ControllerBase
    {
        private readonly IReportTypeUI _iReportTypeUI;

        public ReportTypeController(IReportTypeUI iReportTypeUI)
        {
            _iReportTypeUI = iReportTypeUI;
        }
        [Authorize]
        [HttpGet]
        public ActionResult<IEnumerable<ReportType>> GetReportType()
        {
            return _iReportTypeUI.getAllReportTypes();
        }
    }
}