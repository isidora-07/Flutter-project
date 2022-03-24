using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class PostTypeUI : IPostTypeUI
    {
        private readonly IPostTypeBL _iPostTypeBL;

        public PostTypeUI(IPostTypeBL iPostTypeBL)
        {
            _iPostTypeBL = iPostTypeBL;
        }

        public List<PostType> getAllPostTypes()
        {
            return _iPostTypeBL.getAllPostTypes();
        }

        public PostType getByID(long id)
        {
            return _iPostTypeBL.getByID(id);
        }
    }
}
