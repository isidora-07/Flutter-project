using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class ReportViewModel
    {
        public long id { get; set; }
        public long reportingUserId { get; set; }
        public long reportedUserId { get; set; }
        public string time { get; set; }
        public string description { get; set; }
        public long reportTypeId { get; set; }
        public string username { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string photo { get; set; }
        public string reportTypeName { get; set; }

        public ReportViewModel(Report r)
        {
            this.id = r.id;
            this.reportingUserId = r.reportingUserId;
            this.reportedUserId = r.reportedUserId;
            this.time = r.time.ToString("dd/MM/yyyy");
            this.reportTypeId = r.reportTypeId;
            this.reportTypeName = r.reportType.typeName;
            this.username = r.reportingUser.username;
            this.firstName = r.reportingUser.firstName;
            this.lastName = r.reportingUser.lastName;
            this.photo = r.reportingUser.photo;
            this.description = r.description;
            
        }
    }
}
