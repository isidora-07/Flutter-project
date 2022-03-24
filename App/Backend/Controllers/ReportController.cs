using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReportController : ControllerBase
    {
        private readonly IReportUI _iReportUI;

        public ReportController(IReportUI iReportUI)
        {
            _iReportUI = iReportUI;
        }

        [Authorize]
        [HttpGet]
        public IEnumerable<UserViewModel> GetReportedUsers()
        {
            var users = _iReportUI.getAllReportedUser();
            List<UserViewModel> user = new List<UserViewModel>();
            foreach (var u in users)
            {
                UserViewModel newUser = new UserViewModel(u);
                if (newUser.reportsNum >= 1)
                    user.Add(newUser);
            }
            List<UserViewModel> newList = new List<UserViewModel>(user.OrderByDescending(x => x.reportsNum));
            return newList;
        }
        [Authorize]
        [HttpGet("{id}")]
        public IEnumerable<ReportViewModel> GetReportingUser(long id)
        {
            var reports = _iReportUI.getAllUserWhoHaveReportedUser(id);
            List<ReportViewModel> reportsView = new List<ReportViewModel>();
            foreach (var r in reports)
            {
                reportsView.Add(new ReportViewModel(r));
            }
            return reportsView;
        }

        [Authorize]
        [HttpPost("Insert")]
        public IActionResult InsertReport(Report report)
        {
            Report r = _iReportUI.insertReport(report);
            if (r != null)
                return Ok(r);
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("ReportByCityId")]
        public IEnumerable<UserViewModel> GetReportedUsersByCityId(User user1)
        {
            var users = _iReportUI.getReportedUsersByCityId(user1.cityId);
            List<UserViewModel> user = new List<UserViewModel>();
            foreach (var u in users)
            {
                UserViewModel newUser = new UserViewModel(u);
                if (newUser.reportsNum >= 1)
                    user.Add(newUser);
            }
           List<UserViewModel> newList = new List<UserViewModel>(user.OrderByDescending(x => x.reportsNum));
            return newList;

        }

    }
}