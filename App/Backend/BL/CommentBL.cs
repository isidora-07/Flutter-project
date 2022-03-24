using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class CommentBL : ICommentBL
    {
        private readonly ICommentDAL _iCommentDAL;

        public CommentBL(ICommentDAL iCommentDAL)
        {
            _iCommentDAL = iCommentDAL;
        }

        public bool deleteCommentById(long id)
        {
            return _iCommentDAL.deleteCommentById(id);
        }

        public Comment getByID(long id)
        {
            return _iCommentDAL.getByID(id);
        }

        public List<Comment> getCommentsForPost(long id)
        {
            return _iCommentDAL.getCommentsForPost(id);
        }

        public Comment insertComment(Comment comment)
        {
            return _iCommentDAL.insertComment(comment);
        }
    }
}
