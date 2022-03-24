using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class UserDonation
    {
        public long id { get; set; }
        public long userId { get; set; }
        public virtual User user { get; set; }
        public long donationId { get; set; }
        public virtual Donation donation { get; set; }
        public int donatedPoints { get; set; }
    }
}
