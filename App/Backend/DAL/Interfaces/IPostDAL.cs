using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IPostDAL
    {
        List<Post> getAllPosts();
        List<Post> getAllPostsByCityId(long cityId);
        List<Post> getAllPostsForOneUser(long id);
        List<Post> getAllPostsSolvedByOneInstitution(long id);
        Post getByID(long id);
        Post insertPost(Post post);
        List<Post> getAllSolvedPosts();
        List<Post> getAllUnsolvedPosts();
        List<Post> getPostsByFilter(List<int> filterList, long cityId, int statusId);
        List<Post> getAllSolvedPostsByCityId(long cityId);
        List<Post> getAllUnsolvedPostsByCityId(long cityId);
        List<Post> getAllNicePostsByCityId(long cityId);
        bool deletePost(long id);
        Post editPost(long id, string description);

    }
}
