using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class LikeType
    {
        public long id { get; set; }
        public string typeName { get; set; }

        public IList<Like> likes { get; set; }
    }
}
