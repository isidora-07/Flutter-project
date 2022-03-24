using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface ICommentUI
    {
        List<Comment> getCommentsForPost(long id);
        Comment getByID(long id);
        Comment insertComment(Comment comment);
        bool deleteCommentById(long id);
    }
}
