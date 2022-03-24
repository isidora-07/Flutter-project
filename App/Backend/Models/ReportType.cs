using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class ReportType
    {
        public long id { get; set; }
        public string typeName { get; set; }

        public IList<Report> reports { get; set; }
    }
}
