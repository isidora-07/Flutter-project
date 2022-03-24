using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class PostViewModel
    {
        public long postId { get; set; }
        public long userId { get; set; }
        public long cityId { get; set; }
        public string cityName { get; set; }
        public string username { get; set; }
        public long postTypeId { get; set; }
        public string typeName { get; set; }
        public DateTime createdAt { get; set; }
        public string description { get; set; }
        public string photoPath { get; set; }
        public string solvedPhotoPath { get; set; }
        public long statusId { get; set; }
        public string status { get; set; }
        public int likeNum { get; set; }
        public int dislikeNum { get; set; }
        public int commNum { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }
        public string address { get; set; }
        public String userPhoto { get; set; }
        public int isLiked{ get; set; }

        public PostViewModel (Post p, long userId) 
        {
            this.username = p.user.username;
            this.createdAt = p.createdAt;
            this.description = p.description;
            this.dislikeNum = p.likes.Where(x => x.likeTypeId == 1 && x.postId == p.id).Count();
            this.likeNum = p.likes.Where(x => x.likeTypeId == 2 && x.postId == p.id).Count();
            this.photoPath = p.photoPath;
            this.postId = p.id;
            this.postTypeId = p.postTypeId;
            this.status = p.status.type;
            this.statusId = p.statusId;
            this.userId = p.userId;
            this.typeName = p.postType.typeName;
            this.commNum = p.comments.Where(x => x.postId == p.id).Count();
            this.latitude = p.latitude;
            this.longitude = p.longitude;
            this.userPhoto = p.user.photo;
            this.address = p.address;
            this.cityId = p.cityId;
            this.cityName = p.city.name;
            this.solvedPhotoPath = p.solvedPhotoPath;
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
