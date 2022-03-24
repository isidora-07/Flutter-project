using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface ICommentBL
    {
        List<Comment> getCommentsForPost(long id);
        Comment getByID(long id);
        Comment insertComment(Comment comment);
        bool deleteCommentById(long id);
    }
}
