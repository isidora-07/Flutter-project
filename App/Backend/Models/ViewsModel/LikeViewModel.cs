using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class LikeViewModel
    {
        public long id { get; set; }
        public long postId { get; set; }
        public long userId { get; set; }
        public String time { get; set; }
        public long likeTypeId { get; set; }
        public String username { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String photo { get; set; }

       public LikeViewModel(Like like)
        {
            this.id = like.id;
            this.postId = like.postId;
            this.userId = like.userId;
            this.time = like.time.ToString("dd/MM/yyyy");
            this.likeTypeId = like.likeTypeId;
            this.username = like.user.username;
            this.photo = like.user.photo;
            this.firstName = like.user.firstName;
            this.lastName = like.user.lastName;
        }
    }
}
