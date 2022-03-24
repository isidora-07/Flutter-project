using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class City
    {
        public long id { get; set; }
        public string name { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }

        public IList<User> users { get; set; }
    }
}
