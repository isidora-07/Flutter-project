using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class ChallengeSolvingUI : IChallengeSolvingUI
    {
        private readonly IChallengeSolvingBL _iChallengeSolvingBL;

        public ChallengeSolvingUI(IChallengeSolvingBL iChallengeSolvingBL)
        {
            _iChallengeSolvingBL = iChallengeSolvingBL;
        }

        public bool deleteSolution(long id)
        {
            return _iChallengeSolvingBL.deleteSolution(id);
        }

        public ChallengeSolving editSolution(long id, string description)
        {
            return _iChallengeSolvingBL.editSolution(id, description);
        }

        public List<ChallengeSolving> getAllSolutionsForPost(long postId)
        {
            return _iChallengeSolvingBL.getAllSolutionsForPost(postId);
        }

        public ChallengeSolving insertSolution(ChallengeSolving challenge)
        {
            return _iChallengeSolvingBL.insertSolution(challenge);
        }

        public ChallengeSolving solutionFromTheInstitution(ChallengeSolving challenge)
        {
            return _iChallengeSolvingBL.solutionFromTheInstitution(challenge);
        }

        public List<ChallengeSolving> solvingChallenge(long solutionId, long postId)
        {
            return _iChallengeSolvingBL.solvingChallenge(solutionId, postId);
        }
    }
}
