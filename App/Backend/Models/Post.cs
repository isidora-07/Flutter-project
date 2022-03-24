using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Post
    {
        public long id { get; set; }
        public long userId { get; set; }
        public long postTypeId { get; set; }
        public DateTime createdAt { get; set; }
        public string description { get; set; }
        public string photoPath { get; set; }
        public string solvedPhotoPath { get; set; }
        public long statusId { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }
        public string address { get; set; }
        public virtual Status status { get; set; }
        public virtual PostType postType { get; set; }
        public long cityId { get; set; }
        public virtual City city { get; set; }
        public virtual User user { get; set; }
        
        public IList<Like> likes { get; set; }
        public IList<Comment> comments { get; set; }

    }
}
