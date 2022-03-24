using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class PostUI : IPostUI
    {
        private readonly IPostBL _iPostBL;

        public PostUI(IPostBL iPostBL)
        {
            _iPostBL = iPostBL;
        }

        public bool deletePost(long id)
        {
            return _iPostBL.deletePost(id);
        }

        public Post editPost(long id, string description)
        {
            return _iPostBL.editPost(id, description);
        }

        public List<Post> getAllNicePostsByCityId(long cityId)
        {
            return _iPostBL.getAllNicePostsByCityId(cityId);
        }

        public List<Post> getAllPosts()
        {
            return _iPostBL.getAllPosts();
        }

        public List<Post> getAllPostsByCityId(long cityId)
        {
            return _iPostBL.getAllPostsByCityId(cityId);
        }

        public List<Post> getAllPostsForOneUser(long id)
        {
            return _iPostBL.getAllPostsForOneUser(id);
        }

        public List<Post> getAllPostsSolvedByOneInstitution(long id)
        {
            return _iPostBL.getAllPostsSolvedByOneInstitution(id);
        }

        public List<Post> getAllSolvedPosts()
        {
            return _iPostBL.getAllSolvedPosts();
        }

        public List<Post> getAllSolvedPostsByCityId(long cityId)
        {
            return _iPostBL.getAllSolvedPostsByCityId(cityId);
        }

        public List<Post> getAllUnsolvedPosts()
        {
            return _iPostBL.getAllUnsolvedPosts();
        }

        public List<Post> getAllUnsolvedPostsByCityId(long cityId)
        {
            return _iPostBL.getAllUnsolvedPostsByCityId(cityId);
        }

        public Post getByID(long id)
        {
            return _iPostBL.getByID(id);
        }

        public List<Post> getPostsByFilter(List<int> filterList, long cityId, int statusId)
        {
            return _iPostBL.getPostsByFilter(filterList, cityId, statusId);
        }

        public Post insertPost(Post post)
        {
            return _iPostBL.insertPost(post);
        }
    }
}
