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
    public class CommentController : ControllerBase
    {
        private readonly ICommentUI _iCommentUI;

        public CommentController(ICommentUI iCommentUI)
        {
            _iCommentUI = iCommentUI;
        }

        [Authorize]
        [HttpGet("{id}")]
        public ActionResult<IEnumerable<CommentViewModel>> GetComm(long id) //vraca sve komentar za jedan post
        {
            var comments = _iCommentUI.getCommentsForPost(id);
            List<CommentViewModel> listComm = new List<CommentViewModel>();
            foreach (var comm in comments)
            {
                listComm.Add(new CommentViewModel(comm));
            }

            return listComm;

        }

        [Authorize]
        [HttpPost]
        public IActionResult InsertComment(Comment k)
        {
            Comment comment = _iCommentUI.insertComment(k);
            if (comment != null)
                return Ok(comment);
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [Authorize]
        [HttpPost("Delete")]
        public IActionResult DeleteComment(Comment comment)
        {
            bool ind = _iCommentUI.deleteCommentById(comment.id);
            if (ind == true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }
    }
}