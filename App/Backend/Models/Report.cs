using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Report
    {
        public long id { get; set; }
        public DateTime time { get; set; }
        public long reportTypeId { get; set; }
        public string description { get; set; }
        public virtual ReportType reportType { get; set; }
        public long reportedUserId { get; set; }
        //public virtual User reportedUser { get; set; }
        public long reportingUserId { get; set; }
        public virtual User reportingUser { get; set; }
       
        
    }
}
