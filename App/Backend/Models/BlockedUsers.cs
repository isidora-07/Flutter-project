using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class BlockedUsers
    {
        public long id { get; set; }
        public long userId { get; set; }
        public DateTime blockedUntil { get; set; }
        public virtual User blockedUser { get; set; }
    }
}
