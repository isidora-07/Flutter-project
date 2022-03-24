using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class InstitutionViewModel
    {
        public long id { get; set; }
        public string name { get; set; }
        public string password { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public string description { get; set; }
        public string cityName { get; set; }
        public string photoPath { get; set; }
        public bool authentication { get; set; }
        public int postsNum { get; set; }
        public DateTime createdAt { get; set; }
        public long cityId { get; set; }
        public virtual City city { get; set; }
        private AppDbContext _context = new AppDbContext();
        public InstitutionViewModel(Institution inst)
        {
            this.id = inst.id;
            this.name = inst.name;
            this.password = null;
            this.phone = inst.phone;
            this.email = inst.email;
            this.description = inst.description;
            this.createdAt = inst.createdAt;
            this.cityId = inst.cityId;
            this.authentication = inst.authentication;
            this.cityName = inst.city.name;
            this.photoPath = inst.photoPath;
            this.postsNum = _context.challengeSolving.Where(x => x.institutionId == inst.id && x.selected == 1).Count();
        }
    }
}
