using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewsModel;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class ChallengeSolvingDAL :IChallengeSolvingDAL
    {
        private readonly AppDbContext _context;

        public ChallengeSolvingDAL(AppDbContext context)
        {
            _context = context;
        }

        public bool deleteSolution(long id)
        {
            var sol = _context.challengeSolving.Where(x => x.id == id).FirstOrDefault();
            if (sol == null)
            {
                return false;
            }

            _context.challengeSolving.Remove(sol);
            _context.SaveChangesAsync();

            return true;
        }

        public ChallengeSolving editSolution(long id, string description)
        {
            var exist = _context.challengeSolving.Where(x => x.id == id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.description = description;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.challengeSolving.Where((u) => u.id == id).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public List<ChallengeSolving> getAllSolutionsForPost(long postId)
        {
            return _context.challengeSolving.Where(x => x.postId == postId).OrderByDescending(x => x.selected).Include(u => u.user).Include(s => s.institution).Include(po => po.post).ToList();
        }

        public ChallengeSolving insertSolution(ChallengeSolving challenge)
        {
            ChallengeSolving sol1 = new ChallengeSolving();
            sol1.createdAt = DateTime.Now;
            sol1.description = challenge.description;
            sol1.institutionId = challenge.institutionId;
            sol1.postId = challenge.postId;
            sol1.selected = challenge.selected;
            sol1.solvingPhoto = challenge.solvingPhoto;
            sol1.userId = challenge.userId;

            if (challenge != null)
            {
                _context.challengeSolving.Add(sol1);
                _context.SaveChangesAsync();
                return sol1;
            }
            else
            {
                return null;
            }
        }

        public ChallengeSolving solutionFromTheInstitution(ChallengeSolving challenge)
        {
            if (challenge.institutionId != null)
            {
                ChallengeSolving sol1 = new ChallengeSolving();
                sol1.createdAt = DateTime.Now;
                sol1.description = challenge.description;
                sol1.institutionId = challenge.institutionId;
                sol1.postId = challenge.postId;
                sol1.selected = challenge.selected;
                sol1.solvingPhoto = challenge.solvingPhoto;
                sol1.userId = null;
                sol1.selected = 1;

                if (challenge != null)
                {
                    _context.challengeSolving.Add(sol1);
                    _context.SaveChangesAsync();

                    var exist1 = _context.post.Where(x => x.id == challenge.postId).FirstOrDefault();
                    if (exist1 != null)
                    {
                        exist1.statusId = 1;
                        exist1.solvedPhotoPath = challenge.solvingPhoto;
                        _context.Update(exist1);
                        _context.SaveChanges();
                    }
                    return sol1;
                }
                else
                {
                    return null;
                }
            }
            else return null;
        }

        public List<ChallengeSolving> solvingChallenge(long solutionId, long postId)
        {
            var exist = _context.challengeSolving.Where(x => x.id == solutionId).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.selected = 1;
                    _context.Update(exist);
                    _context.SaveChanges();

                    var exist1 = _context.post.Where(x => x.id == postId).FirstOrDefault();
                    if(exist1 != null)
                    {
                        exist1.statusId = 1;
                        exist1.solvedPhotoPath = exist.solvingPhoto;
                        _context.Update(exist1);
                        _context.SaveChanges();

                        var existUser = _context.user.Where(x => x.id == exist.userId).FirstOrDefault();
                        if(existUser != null)
                        {
                            existUser.points = existUser.points + 10;
                            _context.Update(existUser);
                            _context.SaveChanges();
                        }
                    }
                    return _context.challengeSolving.Where(x => x.postId == postId).OrderByDescending(x => x.selected).Include(u => u.user).Include(s => s.institution).Include(po => po.post).ToList();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }
    }
}
