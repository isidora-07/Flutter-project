using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Like
    {
        public long id { get; set; }
        public long postId { get; set; }
        public long userId { get; set; }
        public DateTime time { get; set; }
        public long likeTypeId { get; set; }

        public virtual User user { get; set; }
        public virtual LikeType LikeType { get; set; }
        public virtual Post post { get; set; }

    }
}
