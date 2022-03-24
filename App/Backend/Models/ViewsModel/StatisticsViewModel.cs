using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class StatisticsViewModel
    {
        public int numberOfPosts { get; set; }
        public int numberOfSolvedPosts { get; set; }
        public int numberOfUnsolvedPosts { get; set; }
        public int numberOfUsers { get; set; }
        public int numberOfInstitutions { get; set; }
        public int numberOfEvents { get; set; }
        public int numberOfActiveEvents { get; set; }
        public int numberOfDonations { get; set; }
        public int numberOfActiveDonations { get; set; }
        public int numberOfNewPostsIn24h { get; set; }
        public int numberOfNewUsersIn24h { get; set; }
        public int numberOfNewInstitutionIn24h { get; set; }
    }
}
