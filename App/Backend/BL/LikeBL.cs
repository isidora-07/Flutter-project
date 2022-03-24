using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class LikeBL : ILikeBL
    {
        private readonly ILikeDAL _iLikeDAL;

        public LikeBL(ILikeDAL iLikeDAL)
        {
            _iLikeDAL = iLikeDAL;
        }
        public Like getByID(long id)
        {
            return _iLikeDAL.getByID(id);
        }

        public List<Like> getDislikeInPost(long id)
        {
            return _iLikeDAL.getDislikeInPost(id);
        }

        public List<Like> getLikeInPost(long id)
        {
            return _iLikeDAL.getLikeInPost(id);
        }

        public Post insertLike(Like like)
        {
            return _iLikeDAL.insertLike(like);
        }
    }
}
