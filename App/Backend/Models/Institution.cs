using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Institution
    {
        public long id { get; set; }
        public string name { get; set; }
        public string password { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public string description { get; set; }
        public string photoPath { get; set; }
        public bool authentication { get; set; }
        public DateTime createdAt { get; set; }
        public long cityId { get; set; }
        public virtual City city { get; set; }
        

    }
}
