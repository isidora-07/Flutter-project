using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class ReportComment
    {
        public long id { get; set; }
        public DateTime time { get; set; }
        public long commentId { get; set; }
        public long userId { get; set; }
        public virtual Comment comment { get; set; }
    }
}
