using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class LikeUI : ILikeUI
    {
        private readonly ILikeBL _iLikeBL;

        public LikeUI(ILikeBL iLikeBL)
        {
            _iLikeBL = iLikeBL;
        }
        public Like getByID(long id)
        {
            return _iLikeBL.getByID(id);
        }

        public List<Like> getDislikeInPost(long id)
        {
            return _iLikeBL.getDislikeInPost(id);
        }

        public List<Like> getLikeInPost(long id)
        {
            return _iLikeBL.getLikeInPost(id);
        }

        public Post insertLike(Like like)
        {
            return _iLikeBL.insertLike(like);
        }
    }
}
