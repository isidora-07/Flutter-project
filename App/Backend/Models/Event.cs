using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Event
    {
        public long id { get; set; }
        public long? institutionId { get; set; }
        public virtual Institution institution { get; set; }
        public long? adminId { get; set; }
        public virtual Admin admin { get; set; }
        public long cityId { get; set; }
        public virtual City city { get; set; }
        public DateTime startDate { get; set; }
        public DateTime endDate { get; set; }
        public string shortDescription { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }
        public string address { get; set; }
        public string title { get; set; }
        public string description { get; set; }

    }
}
