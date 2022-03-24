using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class LikeCountViewModel
    {
        public long postId { get; set; }
        public int likeNum { get; set; }
        public int dislikeNum { get; set; }
        public int commNum { get; set; }
        public int isLiked { get; set; }
        public LikeCountViewModel(Post p, long userId)
        {
            this.dislikeNum = p.likes.Where(x => x.likeTypeId == 1 && x.postId == p.id).Count();
            this.likeNum = p.likes.Where(x => x.likeTypeId == 2 && x.postId == p.id).Count();
            this.postId = p.id;
            this.commNum = p.comments.Where(x => x.postId == p.id).Count();
            Like like = p.likes.Where(x => x.userId == userId).FirstOrDefault();
            if (like == null)
                this.isLiked = 0;
            else if (like.likeTypeId == 1)
            {
                this.isLiked = 2; //dislike
            }
            else
                this.isLiked = 1;
        }
    }
}
