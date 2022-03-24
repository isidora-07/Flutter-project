using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChallengeSolvingController : ControllerBase
    {
        private readonly IChallengeSolvingUI _iChallengeSolvingUI;

        public ChallengeSolvingController(IChallengeSolvingUI iChallengeSolvingUI)
        {
            _iChallengeSolvingUI = iChallengeSolvingUI;
        }

        [Authorize]
        [HttpGet("postId={postId}/userId={userID}")]
        public ActionResult<IEnumerable<ChallengeSolvingViewModel>> GetChallenges(int postId, int userId)
        {
            var solvings = _iChallengeSolvingUI.getAllSolutionsForPost(postId);
            List<ChallengeSolvingViewModel> listSol = new List<ChallengeSolvingViewModel>();
            foreach (var sol in solvings)
            {
                listSol.Add(new ChallengeSolvingViewModel(sol, userId));
            }
            return listSol;
        }

        [Authorize]
        [HttpPost]
        public IActionResult InsertSolution(ChallengeSolving sol)
        {
            ChallengeSolving p = _iChallengeSolvingUI.insertSolution(sol);
            if (p != null)
                return Ok(p);
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("solutionFromTheInstitution")]
        public IActionResult InsertSolutionFromTheInstitution(ChallengeSolving sol)
        {
            ChallengeSolving p = _iChallengeSolvingUI.solutionFromTheInstitution(sol);
            if (p != null)
                return Ok(p);
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("editSolution")]
        public IActionResult EditSolution(ChallengeSolving sol)
        {
            ChallengeSolving p = _iChallengeSolvingUI.editSolution(sol.id, sol.description);
            if (p != null)
            {
                return Ok(p);
            }
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("solvingChallenge")]
        public ActionResult<IEnumerable<ChallengeSolvingViewModel>> SolvingChallenge(ChallengeSolving solut)
        {
            var solvings = _iChallengeSolvingUI.solvingChallenge(solut.id, solut.postId);
            List<ChallengeSolvingViewModel> listSol = new List<ChallengeSolvingViewModel>();
            foreach (var sol in solvings)
            {
                listSol.Add(new ChallengeSolvingViewModel(sol, solut.userId));
            }
            return listSol;
        }

        [Authorize]
        [HttpPost("Delete")]
        public IActionResult DeleteSolution (ChallengeSolving solution)
        {
            bool ind = _iChallengeSolvingUI.deleteSolution(solution.id);
            if (ind == true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

    }
}