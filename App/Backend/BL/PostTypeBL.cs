using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class PostTypeBL : IPostTypeBL
    {
        private readonly IPostTypeDAL _iPostTypeDAL;

        public PostTypeBL(IPostTypeDAL iPostTypeDAL)
        {
            _iPostTypeDAL = iPostTypeDAL;
        }

        public List<PostType> getAllPostTypes()
        {
            return _iPostTypeDAL.getAllPostTypes();
        }

        public PostType getByID(long id)
        {
            return _iPostTypeDAL.getByID(id);
        }
    }
}
