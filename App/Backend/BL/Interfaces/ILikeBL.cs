using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface ILikeBL
    {
        List<Like> getLikeInPost(long id);
        List<Like> getDislikeInPost(long id);
        Like getByID(long id);
        Post insertLike(Like like);
    }
}
