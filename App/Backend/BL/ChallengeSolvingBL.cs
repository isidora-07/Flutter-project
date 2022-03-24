using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class ChallengeSolvingBL : IChallengeSolvingBL
    {
        private readonly IChallengeSolvingDAL _iChallengeSolvingDAL;

        public ChallengeSolvingBL(IChallengeSolvingDAL iChallengeSolvingDAL)
        {
            _iChallengeSolvingDAL = iChallengeSolvingDAL;
        }

        public bool deleteSolution(long id)
        {
            return _iChallengeSolvingDAL.deleteSolution(id);
        }

        public ChallengeSolving editSolution(long id, string description)
        {
            return _iChallengeSolvingDAL.editSolution(id, description);
        }

        public List<ChallengeSolving> getAllSolutionsForPost(long postId)
        {
            return _iChallengeSolvingDAL.getAllSolutionsForPost(postId);
        }

        public ChallengeSolving insertSolution(ChallengeSolving challenge)
        {
            return _iChallengeSolvingDAL.insertSolution(challenge);
        }

        public ChallengeSolving solutionFromTheInstitution(ChallengeSolving challenge)
        {
            return _iChallengeSolvingDAL.solutionFromTheInstitution(challenge);
        }

        public List<ChallengeSolving> solvingChallenge(long solutionId, long postId)
        {
            return _iChallengeSolvingDAL.solvingChallenge(solutionId, postId);
        }
    }
}
