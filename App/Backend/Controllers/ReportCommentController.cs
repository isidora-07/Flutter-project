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
    public class ReportCommentController : ControllerBase
    {
        private readonly IReportCommentUI _iReportCommentUI;

        public ReportCommentController(IReportCommentUI iReportCommentUI)
        {
            _iReportCommentUI = iReportCommentUI;
        }

        [Authorize]
        [HttpGet]
        public IEnumerable<Comment> GetReportedComment()
        {
            var comment = _iReportCommentUI.getAllReportedComment();
            List<Comment> comm = new List<Comment>();
            foreach (var c in comment)
            {
                comm.Add(c.comment);
            }
            return comm;
        }

        [Authorize]
        [HttpPost("Insert")]
        public IActionResult InsertReport(ReportComment report)
        {
            ReportComment r = _iReportCommentUI.insertReportComment(report);
            if (r != null)
                return Ok(r);
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

    }
}