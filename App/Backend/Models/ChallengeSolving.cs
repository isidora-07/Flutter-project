using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class ChallengeSolving
    {
        public long id { get; set; }
        public long? institutionId { get; set; }
        public virtual Institution institution { get; set; }
        public long? userId { get; set; }
        public virtual User user { get; set; }
        public long postId { get; set; }
        public virtual Post post { get; set; }
        public DateTime createdAt { get; set; }
        public string description { get; set; }
        public string solvingPhoto { get; set; }
        public int selected { get; set; }
    }
}
