using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface ILikeUI
    {
        List<Like> getLikeInPost(long id);
        List<Like> getDislikeInPost(long id);
        Like getByID(long id);
        Post insertLike(Like like);
    }
}
