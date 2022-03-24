using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Donation
    {
        public long id { get; set; }
        public long adminId { get; set; }
        public virtual Admin admin { get; set; }
        public string title { get; set; }
        public string organizationName { get; set; }
        public string description { get; set; }
        public double monetaryAmount { get; set; }
        public double collectedMoney { get; set; }
    }
}
