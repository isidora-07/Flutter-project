using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface ILikeDAL
    {
        List<Like> getLikeInPost(long id);
        List<Like> getDislikeInPost(long id);
        Like getByID(long id);
        Post insertLike(Like like);
    }
}
