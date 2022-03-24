using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class UserEvent
    {
        public long id { get; set; }
        public long? institutionId { get; set; }
        public virtual Institution institution { get; set; }
        public long? userId { get; set; }
        public virtual User user { get; set; }
        public long eventId { get; set; }
        public virtual Event events { get; set; }
    }
}
