using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IPostUI
    {
        List<Post> getAllPosts();
        List<Post> getAllPostsByCityId(long cityId);
        List<Post> getAllPostsForOneUser(long id);
        List<Post> getAllPostsSolvedByOneInstitution(long id);
        Post getByID(long id);
        Post insertPost(Post post);
        List<Post> getPostsByFilter(List<int> filterList, long cityId, int statusId);
        List<Post> getAllSolvedPosts();
        List<Post> getAllUnsolvedPosts();
        bool deletePost(long id);
        Post editPost(long id, string description);
        List<Post> getAllSolvedPostsByCityId(long cityId);
        List<Post> getAllUnsolvedPostsByCityId(long cityId);
        List<Post> getAllNicePostsByCityId(long cityId);
    }
}
