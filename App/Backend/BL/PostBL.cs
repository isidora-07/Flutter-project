using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class PostBL : IPostBL
    {
        private readonly IPostDAL _iPostDAL;

        public PostBL(IPostDAL iPostDAL)
        {
            _iPostDAL = iPostDAL;
        }

        public bool deletePost(long id)
        {
            return _iPostDAL.deletePost(id);
        }

        public Post editPost(long id, string description)
        {
            return _iPostDAL.editPost(id, description);
        }

        public List<Post> getAllNicePostsByCityId(long cityId)
        {
            return _iPostDAL.getAllNicePostsByCityId(cityId);
        }

        public List<Post> getAllPosts()
        {
            return _iPostDAL.getAllPosts();
        }

        public List<Post> getAllPostsByCityId(long cityId)
        {
            return _iPostDAL.getAllPostsByCityId(cityId);
        }

        public List<Post> getAllPostsForOneUser(long id)
        {
            return _iPostDAL.getAllPostsForOneUser(id);
        }

        public List<Post> getAllPostsSolvedByOneInstitution(long id)
        {
            return _iPostDAL.getAllPostsSolvedByOneInstitution(id);
        }

        public List<Post> getAllSolvedPosts()
        {
            return _iPostDAL.getAllSolvedPosts();
        }

        public List<Post> getAllSolvedPostsByCityId(long cityId)
        {
            return _iPostDAL.getAllSolvedPostsByCityId(cityId);
        }

        public List<Post> getAllUnsolvedPosts()
        {
            return _iPostDAL.getAllUnsolvedPosts();
        }

        public List<Post> getAllUnsolvedPostsByCityId(long cityId)
        {
            return _iPostDAL.getAllUnsolvedPostsByCityId(cityId);
        }

        public Post getByID(long id)
        {
            return _iPostDAL.getByID(id);
        }

        public List<Post> getPostsByFilter(List<int> filterList, long cityId, int statusId)
        {
            return _iPostDAL.getPostsByFilter(filterList, cityId, statusId);
        }

        public Post insertPost(Post post)
        {
            return _iPostDAL.insertPost(post);
        }
    }
}
