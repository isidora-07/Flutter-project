using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StatisticsController : ControllerBase
    {
        private readonly IStatisticsUI _iStatisticsUI;

        public StatisticsController(IStatisticsUI iStatisticsUI)
        {
            _iStatisticsUI = iStatisticsUI;
        }

        [Authorize]
        [HttpGet]
        public StatisticsViewModel GetStatistics()
        {
            return _iStatisticsUI.basicStatistics();
        }
        [Authorize]
        [HttpGet("Top10")]
        public IEnumerable<UserViewModel> GetTop10Users()
        {
            var users = _iStatisticsUI.top10Users();
            return users;

        }
        [Authorize]
        [HttpGet("MonthlyUsers")]
        public IEnumerable<int> GetMonthlyUsers()
        {
            var users = _iStatisticsUI.monthlyUsers();
            return users;

        }

        [Authorize]
        [HttpGet("PostsByType")]
        public IEnumerable<int> PostsByType()
        {
            var posts = _iStatisticsUI.postsByType();
            return posts;

        }
    }
}