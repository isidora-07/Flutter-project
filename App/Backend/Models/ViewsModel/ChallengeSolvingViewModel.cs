using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class ChallengeSolvingViewModel
    {
        public long id { get; set; }
        public long postId { get; set; }
        public long? institutionId { get; set; }
        public long? userId { get; set; }
        public string username { get; set; }
        public string createdAt { get; set; }
        public long postStatusId { get; set; }//1 solved
        public string description { get; set; }
        public string solvingPhoto { get; set; }
        public string userPhoto { get; set; }
        public bool isOwnerOfPost { get; set; }
        public bool isOwnerOfSolution { get; set; }
        public int selected { get; set; } //1 the winning solution 

        public ChallengeSolvingViewModel(ChallengeSolving challenge, long? userID )
        {
            this.id = challenge.id;
            this.postId = challenge.postId;
            if(challenge.userId != null)
            {
                this.userId = challenge.userId;
                this.username = challenge.user.username;
                this.userPhoto = challenge.user.photo;
                if (this.userId == challenge.post.userId)
                    this.isOwnerOfPost = true;
                else
                    this.isOwnerOfPost = false;
                if (this.userId == userID)
                    this.isOwnerOfSolution = true;
                else
                    this.isOwnerOfSolution = false;
            }
            else
            {
                this.institutionId = challenge.institutionId;
                this.username = challenge.institution.name;
                this.userPhoto = challenge.institution.photoPath;
                this.isOwnerOfPost = false;
                this.isOwnerOfSolution = false;
            }
            this.createdAt = challenge.createdAt.ToString("dd/MM/yyyy HH:mm");
            this.description = challenge.description;
            this.postStatusId = challenge.post.statusId; 
            this.selected = challenge.selected;
            this.solvingPhoto = challenge.solvingPhoto;
        }
    }
}
