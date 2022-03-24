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
    public class BlockedUsersController : ControllerBase
    {
        private readonly IBlockedUsersUI _iBlockedUsersUI;

        public BlockedUsersController(IBlockedUsersUI iBlockedUsersUI)
        {
            _iBlockedUsersUI = iBlockedUsersUI;
        }

        [Authorize]
        [HttpGet]
        public IEnumerable<User> GetBlockedUsers()
        {
            var block = _iBlockedUsersUI.getAllBlockedUsers();
            List<User> user = new List<User>();
            foreach (var u in block)
            {
                    user.Add(u.blockedUser);
            }
            return user;
        }

        [Authorize]
        [HttpPost("Insert")]
        public IActionResult InsertBlock(BlockedUsers block)
        {
            BlockedUsers b = _iBlockedUsersUI.insertBlock(block);
            if (b != null)
                return Ok(b);
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

    }
}