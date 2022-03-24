using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class CommentUI :ICommentUI
    {
        private readonly ICommentBL _iCommentBL;

        public CommentUI(ICommentBL iCommentBL)
        {
            _iCommentBL = iCommentBL;
        }

        public bool deleteCommentById(long id)
        {
            return _iCommentBL.deleteCommentById(id);
        }

        public Comment getByID(long id)
        {
            return _iCommentBL.getByID(id);
        }

        public List<Comment> getCommentsForPost(long id)
        {
            return _iCommentBL.getCommentsForPost(id);
        }

        public Comment insertComment(Comment comment)
        {
            return _iCommentBL.insertComment(comment);
        }
    }
}
