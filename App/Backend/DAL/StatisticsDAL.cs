using Backend.DAL.Interfaces;
using Backend.Models.ViewsModel;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class StatisticsDAL : IStatisticsDAL
    {

        private readonly AppDbContext _context;
        public StatisticsDAL(AppDbContext context)
        {
            _context = context;
        }

        public List<UserViewModel> top10Users()
        {
            var users = _context.user.Include(x => x.city).Include(p => p.posts).OrderByDescending(x => x.donatedPoints + x.points).ToList().Take(10);
            List<UserViewModel> listUser = new List<UserViewModel>();
            foreach (var item in users)
            {
                listUser.Add(new UserViewModel(item));
            }
            return listUser;
        }

        public List<int> monthlyUsers()
        {
            List<int> mounthly = new List<int>();
            int br=0;
            for (int i = 12; i > 0; i--)
            {
                br = _context.user.Where(x => x.createdAt.Year == DateTime.Now.Year && x.createdAt.Month == DateTime.Now.AddMonths(-i).Month).Count();
                mounthly.Add(br);
            }
            return mounthly;
        }

        public StatisticsViewModel basicStatistics()
        {
            StatisticsViewModel statistics = new StatisticsViewModel();
            statistics.numberOfPosts = _context.post.Count();
            statistics.numberOfSolvedPosts = _context.post.Where(x=> x.statusId == 1).Count();
            statistics.numberOfUnsolvedPosts = _context.post.Where(x=> x.statusId == 2).Count();
            statistics.numberOfUsers = _context.user.Count();
            statistics.numberOfInstitutions = _context.institution.Count();
            statistics.numberOfEvents = _context.events.Count();
            statistics.numberOfDonations = _context.donation.Count();
            statistics.numberOfNewInstitutionIn24h = _context.institution.Where(x=> x.createdAt >= DateTime.Now.AddHours(-24)).Count();
            statistics.numberOfNewPostsIn24h = _context.post.Where(x=> x.createdAt >= DateTime.Now.AddHours(-24)).Count();
            statistics.numberOfNewUsersIn24h = _context.user.Where(x=> x.createdAt >= DateTime.Now.AddHours(-24)).Count();
            statistics.numberOfActiveEvents = _context.events.Where(x => x.endDate > DateTime.Now).Count();
            statistics.numberOfActiveDonations = _context.donation.Where(x => x.collectedMoney < x.monetaryAmount).Count();
            return statistics;
        }

        public List<int> postsByType()
        {
            List<int> posts = new List<int>();
            int br;
            int types = _context.postType.Count();
            for (int i = 1; i <= types ; i++)
            {
                br = _context.post.Where(x => x.postTypeId == i).Count();
                posts.Add(br);
            }
            return posts;
        }
    }
}
