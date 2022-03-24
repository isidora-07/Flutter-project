using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class PostTypeDAL : IPostTypeDAL
    {
        private readonly AppDbContext _context;

        public PostTypeDAL(AppDbContext context)
        {
            _context = context;
        }

        public List<PostType> getAllPostTypes()
        {
            return _context.postType.Where(x => x.id != 1).ToList();
        }

        public PostType getByID(long id)
        {
            return _context.postType.Where(x => x.id == id).FirstOrDefault();
        }
    }
}
