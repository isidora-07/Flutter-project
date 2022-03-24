using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class CommentViewModel
    {
        public long id { get; set; }
        public long postId { get; set; }
        public long userId { get; set; }
        public DateTime createdAt { get; set; }
        public string description { get; set; }
        public string username { get; set; }
        public string photoPath { get; set; }
        public string date { get; set; }
        public int reportNum { get; set; }
        private AppDbContext _context = new AppDbContext();

        public CommentViewModel (Comment com)
        {
            this.description = com.description;
            this.id = com.id;
            this.postId = com.postId;
            this.userId = com.userId;
            this.username = com.user.username;
            this.photoPath = com.user.photo;
            this.date = com.createdAt.ToString("dd/MM/yyyy");
            this.reportNum = _context.reportComment.Where(x => x.commentId == com.id).Count();
        }
    }
}
