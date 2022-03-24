using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IPostTypeBL
    {
        List<PostType> getAllPostTypes();
        PostType getByID(long id);
    }
}
