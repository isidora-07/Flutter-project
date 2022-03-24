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
    public class LikeController : ControllerBase
    {
        private readonly ILikeUI _iLikeUI;

        public LikeController(ILikeUI iLikeUI)
        {
            _iLikeUI = iLikeUI;
        }

        [Authorize]
        [HttpPost]
        public IActionResult InsertLike(Like l)
        {
            Post post = _iLikeUI.insertLike(l);
            if (post != null)
            {
                LikeCountViewModel like = new LikeCountViewModel(post, l.userId);
                return Ok(like);
            }
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("DislikeInPost")]
        public IEnumerable<LikeViewModel> DislikeInPost([FromBody] Post postParam)
        {
            var dislikes = _iLikeUI.getDislikeInPost(postParam.id);
            List<LikeViewModel> likes = new List<LikeViewModel>();
            foreach (var d in dislikes)
            {
                likes.Add(new LikeViewModel(d));
            }

            return likes;
        }

        [Authorize]
        [HttpPost("LikeInPost")]
        public IEnumerable<LikeViewModel> LikeInPost([FromBody] Post postParam)
        {
            var like = _iLikeUI.getLikeInPost(postParam.id);
            List<LikeViewModel> likes = new List<LikeViewModel>();
            foreach (var l in like)
            {
                likes.Add(new LikeViewModel(l));
            }
            return likes;
        }

    }
}