using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class LikeDAL : ILikeDAL
    {
        private readonly AppDbContext _context;

        public LikeDAL(AppDbContext context)
        {
            _context = context;
        }

        public Like getByID(long id)
        {
            return _context.like.Where(l => l.id == id).FirstOrDefault();
        }

        public List<Like> getDislikeInPost(long id)
        {
            return _context.like.Where(l => l.likeTypeId == 1 && l.postId == id).Include(x => x.user).ToList();
        }

        public List<Like> getLikeInPost(long id)
        {
            return _context.like.Where(l => l.postId == id && l.likeTypeId == 2).Include(x => x.user).Include(t=> t.LikeType).Include(p=> p.post).ToList();
        }

        public Post insertLike(Like like)
        {
            Like like1 = new Like();

            like1.likeTypeId = like.likeTypeId;
            like1.userId = like.userId;
            like1.postId = like.postId;
            like1.time = DateTime.Now;

            int typeId = like.likeTypeId == 1 ? 2 : 1;
            Like like2 = _context.like.Where(x => x.likeTypeId == typeId && x.postId == like.postId && x.userId == like.userId).FirstOrDefault();

            if (like2 != null) //User have another type of like 
            {
                _context.like.Remove(like2);
                _context.like.Add(like1);
                _context.SaveChangesAsync();
                return _context.post.Where(x => x.id == like1.postId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).FirstOrDefault();
            }
            else
            {
                Like like3 = _context.like.Where(x => x.postId == like.postId && x.userId == like.userId).FirstOrDefault();
                if (like3 == null)//ne postoji isti lajk pa se moze dodati u bazu
                {
                    _context.like.Add(like1);
                    _context.SaveChangesAsync();
                    return _context.post.Where(x => x.id == like1.postId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).FirstOrDefault();
                  
                }
                else
                {
                    _context.like.Remove(like3);
                    _context.SaveChangesAsync();
                    return _context.post.Where(x => x.id == like1.postId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).FirstOrDefault();
                }
            }

            
        }
    }
}
