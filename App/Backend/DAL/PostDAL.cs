using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class PostDAL : IPostDAL
    {
        private readonly AppDbContext _context;
        public static IWebHostEnvironment _environment;

        public PostDAL(AppDbContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        public bool deletePost(long id)
        {
            var post = _context.post.Where(x => x.id == id).FirstOrDefault();
            if (post == null)
            {
                return false;
            }
            List<String> listStr;
            listStr = post.photoPath.Split('/').ToList();
            var path = Path.Combine($"{_environment.ContentRootPath}/", "wwwroot/Upload/Post/", listStr[listStr.Count - 1]);
            var PathWithFolder = System.IO.Path.Combine(_environment.WebRootPath, post.photoPath);

            if (System.IO.File.Exists(PathWithFolder))
            {
                System.IO.File.Delete(PathWithFolder);
            }
            if(post.solvedPhotoPath != null && post.solvedPhotoPath != "")
            { 
                listStr = post.solvedPhotoPath.Split('/').ToList();
                path = Path.Combine($"{_environment.ContentRootPath}/", "wwwroot/Upload/Post/", listStr[listStr.Count - 1]);
                PathWithFolder = System.IO.Path.Combine(_environment.WebRootPath, post.solvedPhotoPath);

                if (System.IO.File.Exists(PathWithFolder))
                {
                    System.IO.File.Delete(PathWithFolder);
                }
            }
            _context.post.Remove(post);
            _context.SaveChangesAsync();

            return true;
        }

        public Post editPost(long id, string description)
        {
            var exist = _context.post.Where(x => x.id == id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.description = description;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.post.Where((u) => u.id == id).Include(u => u.user).Include(s => s.status).Include(po => po.postType).Include(l => l.likes).Include(c => c.comments).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public List<Post> getAllPosts()
        {
            return _context.post.Include(u => u.user).Include(c=> c.postType).Include(s=>s.status).Include(l => l.likes).Include(c => c.comments).Include(c=> c.city).OrderByDescending(x=>x.id).ToList();
        }

        public List<Post> getAllPostsByCityId(long cityId)
        {
            return _context.post.Where(c=> c.cityId == cityId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).Include(c => c.city).OrderByDescending(x => x.id).ToList();
        }

        public List<Post> getAllPostsSolvedByOneInstitution(long id)
        {
            var solutions = _context.challengeSolving.Where(x => x.institutionId == id && x.selected == 1).ToList();
            List<Post> listPosts = new List<Post>();

            foreach (var sol in solutions)
            {
                var post = _context.post.Where(x => x.id == sol.postId).Include(u => u.user).Include(s => s.status).Include(po => po.postType).Include(l => l.likes).Include(c => c.comments).Include(c => c.city).FirstOrDefault();
                listPosts.Add(post);
            }

            listPosts.OrderByDescending(x => x.id);
            return listPosts;
            
        }

        public List<Post> getAllPostsForOneUser(long id)
        {
            return _context.post.Where(x => x.userId == id).Include(u => u.user).Include(s => s.status).Include(po => po.postType).Include(l => l.likes).Include(c => c.comments).Include(c => c.city).OrderByDescending(x => x.id).ToList();
        }

        public List<Post> getAllSolvedPosts()
        {
            return _context.post.Where(x=> x.statusId==1 && x.postTypeId!=1).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).Include(c => c.city).ToList();
        }

        public List<Post> getAllSolvedPostsByCityId(long cityId)
        {
            return _context.post.Where(x => x.statusId == 1 && x.cityId == cityId && x.postTypeId!=1).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).Include(c => c.city).ToList();
        }

        public List<Post> getAllUnsolvedPosts()
        {
            return _context.post.Where(x => x.statusId == 2 && x.postTypeId != 1).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).Include(s => s.status).Include(c => c.city).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).ToList();
        }

        public List<Post> getAllUnsolvedPostsByCityId(long cityId)
        {
            return _context.post.Where(x => x.statusId == 2 && x.cityId == cityId && x.postTypeId!=1).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).Include(s => s.status).Include(c => c.city).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).ToList();
        }

        public Post getByID(long id)
        {
            return _context.post.Where(x => x.id == id).Include(u => u.user).Include(s => s.status).Include(po => po.postType).Include(l => l.likes).Include(c => c.comments).Include(c => c.city).FirstOrDefault();
        }

        public Post insertPost(Post post)
        {
            Post post1 = new Post();

            post1.userId = post.userId;
            post1.postTypeId = post.postTypeId;
            post1.createdAt = DateTime.Now;
            post1.description = post.description;
            post1.photoPath = post.photoPath;
            post1.address = post.address;
            post1.statusId = post.statusId;
            post1.latitude = post.latitude;
            post1.longitude = post.longitude;
            post1.solvedPhotoPath = post.solvedPhotoPath;
            post1.cityId = post.cityId;

            if (post != null)
            {
                _context.post.Add(post1);
                _context.SaveChangesAsync();

                if(post.statusId == 1)
                {
                    var user = _context.user.Where(x => x.id == post.userId).FirstOrDefault();
                    if(user != null)
                    {
                        user.points += 10;
                        _context.Update(user);
                        _context.SaveChangesAsync();
                    }
                }
                return post1;
            }
            else
            {
                return null;
            }

        }

        public List<Post> getPostsByFilter(List<int> filterList, long cityId, int statusId)
        {
            List<Post> posts = new List<Post>();
            if(filterList != null)
            { 
                for (int i = 0; i < filterList.Count; i++)
                {
                    if(statusId == 0)
                    { 
                        var listPosts = _context.post.Where(x => x.postTypeId == filterList[i] && x.cityId == cityId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).Include(c => c.city).ToList();
                        foreach (var item in listPosts)
                        {
                            posts.Add(item);
                        }
                    }
                    else
                    {
                        var listPosts = _context.post.Where(x => x.postTypeId == filterList[i] && x.statusId == 2 && x.cityId == cityId).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).Include(c => c.city).ToList();
                        foreach (var item in listPosts)
                        {
                            posts.Add(item);
                        }

                    }
                }
                return posts;
            }
            return null;
        }

        public List<Post> getAllNicePostsByCityId(long cityId)
        {
            return _context.post.Where(x => x.cityId == cityId && x.postTypeId == 1).Include(u => u.user).Include(c => c.postType).Include(s => s.status).Include(l => l.likes).Include(c => c.comments).Include(s => s.status).Include(c => c.city).Include(l => l.likes).Include(c => c.comments).OrderByDescending(x => x.id).ToList();
        }
    }
}
