using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewsModel
{
    public class NotificationViewModel
    { 
        public long?  userId { get; set; } 
        public long? institutionId { get; set; } 
        public string username { get; set; }
        public string userPhoto { get; set; } // slika korisnika koji je lakovao, kom...
        public string photoPath { get; set; } //slika objave, ili resenja
        public long postId { get; set; } //slika objave, ili resenja
        public int typeNotification { get; set; }  // 1 - neko je postavio resenje na objavu, 2 - nase resenje je izabrano kao pobednicko, 3- lajk , 4-komm 
        public string createdAtString { get; set; }  // 1 - neko je postavio resenje na objavu, 2 - nase resenje je izabrano kao pobednicko, 3- lajk , 4-komm 
        public DateTime createdAt { get; set; }  // 1 - neko je postavio resenje na objavu, 2 - nase resenje je izabrano kao pobednicko, 3- lajk , 4-komm 
       
       
        public NotificationViewModel(long? userId, long? instId, string username, string userPhoto, string photoPath, long postId, int typeNot, DateTime createdAt)
        {
            this.userId = userId;
            this.institutionId = instId;
            this.username = username;
            this.userPhoto = userPhoto;
            this.photoPath = photoPath;
            this.postId = postId;
            this.typeNotification = typeNot;
            this.createdAt = createdAt;
            this.createdAtString = createdAt.ToString("dd/MM/yyyy HH:mm");
        }
    }
}
