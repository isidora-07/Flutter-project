using Backend.DAL.Interfaces;
using Backend.Models.ViewsModel;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class DisplayNotificationsDAL : IDisplayNotificationsDAL
    {
        private readonly AppDbContext _context;

        public DisplayNotificationsDAL(AppDbContext context)
        {
            _context = context;
        }

        public List<NotificationViewModel> solutionsForNotification(long userId)
        {
            var solutions = _context.challengeSolving.Include(x => x.post).Where(x => x.post.userId == userId).Include(x => x.institution).Include(x => x.user).OrderBy(x => x.createdAt).ToList();
            List<NotificationViewModel> listNot = new List<NotificationViewModel>();
            foreach (var item in solutions)
            {
                if (item.userId != null && item.userId != userId)
                {
                    listNot.Add(new NotificationViewModel(item.userId, null, item.user.username, item.user.photo, item.solvingPhoto, item.postId, 1, item.createdAt));
                }
                else if (item.userId == null)
                {
                    listNot.Add(new NotificationViewModel(null, item.institutionId, item.institution.name, item.institution.photoPath, item.solvingPhoto, item.postId, 1, item.createdAt));
                }
            }
            //izabrali njegovo resenje -- ne prikazuje se kada izabere sam sebe
            var solutions1 = _context.challengeSolving.Include(x => x.user).Include(x => x.post).Where(x => x.userId == userId && x.selected == 1 && x.post.userId != userId).OrderBy(x => x.createdAt).ToList();
            foreach (var item in solutions1)
            {
                if (item.userId != null )
                {
                    listNot.Add(new NotificationViewModel(item.post.userId, null, "ime", "slika", item.solvingPhoto, item.postId, 2, item.createdAt));

                }
            }

            var likes = _context.like.Include(x => x.post).Include(x => x.user).Where(x => x.post.userId == userId).ToList();

            foreach (var item in likes)
            {
                if(item.userId != userId && item.likeTypeId == 1)
                    listNot.Add(new NotificationViewModel(item.userId, null, item.user.username, item.user.photo, item.post.photoPath, item.postId, 3, item.time));
                if (item.userId != userId && item.likeTypeId == 2)
                    listNot.Add(new NotificationViewModel(item.userId, null, item.user.username, item.user.photo, item.post.photoPath, item.postId, 4, item.time));
            }

            var comments = _context.comment.Include(x => x.post).Include(x => x.user).Where(x => x.post.userId == userId).ToList();
            foreach (var item in comments)
            {
                if (item.userId != userId)
                    listNot.Add(new NotificationViewModel(item.userId, null, item.user.username, item.user.photo, item.post.photoPath, item.postId, 5, item.createdAt));
            }

            var newList = listNot.OrderByDescending(x => x.createdAt).ToList();
            return newList;
        }
    }
}
