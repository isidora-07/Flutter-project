using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PostTypeController : ControllerBase
    {
        private readonly IPostTypeUI _iPostTypeUI;

        public PostTypeController(IPostTypeUI iPostTypeUI)
        {
            _iPostTypeUI = iPostTypeUI;
        }

        [Authorize]
        [HttpGet]
        public ActionResult<IEnumerable<PostType>> GetPostType()
        {
            return _iPostTypeUI.getAllPostTypes();
        }


    }
}