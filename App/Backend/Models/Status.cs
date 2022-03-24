using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Status
    {
        public long id { get; set; }
        public string type { get; set; }

        public IList<Post> posts { get; set; }
    }
}
