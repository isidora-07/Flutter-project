using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class UserViewModel
    {
        public long id { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public DateTime createdAt { get; set; }
        public string cityName { get; set; }
        public long cityId { get; set; }
        public int points { get; set; }
        public int donatedPoints { get; set; }
        public int level { get; set; }
        public string photo { get; set; }
        public int postsNum { get; set; }
        public int reportsNum { get; set; }
        public bool darkTheme { get; set; }

        private AppDbContext _context = new AppDbContext();


        public UserViewModel(User u)
        {
            this.firstName = u.firstName;
            this.lastName = u.lastName;
            this.email = u.email;
            this.password = null;
            this.username = u.username;
            this.phone = u.phone;
            this.createdAt = u.createdAt;
            this.id = u.id;
            this.points = u.points;
            this.level = (u.points + u.donatedPoints)/100 + 1;
            this.cityName = u.city.name;
            this.cityId = u.cityId;
            this.photo = u.photo;
            this.darkTheme = u.darkTheme;
            this.donatedPoints = u.donatedPoints;
            this.postsNum = u.posts.Where(x => x.userId == u.id).Count();
            this.reportsNum = _context.report.Where(x => x.reportedUserId == u.id).Count();
        }
    }
}
