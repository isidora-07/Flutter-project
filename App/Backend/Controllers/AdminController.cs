using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static Backend.Controllers.UserController;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AdminController : ControllerBase
    {
        private readonly IAdminUI _iAdminUI;

        public AdminController(IAdminUI iAdminUI)
        {
            _iAdminUI = iAdminUI;
        }

        [Authorize]
        [HttpGet]
        public IEnumerable<Admin> GetAdmins()
        {
            return _iAdminUI.getAllAdmins();
        }

        [Authorize]
        [HttpGet("{id}")]
        public Admin GetAdmin(long id)
        {
            return _iAdminUI.getByID(id);
        }


        [HttpPost("Login")]
        public IActionResult Login([FromBody] Admin adminParam)
        {
            string tokenStr = _iAdminUI.login(adminParam);
            if (tokenStr != null)
            {
                return Ok(new { token = tokenStr });
            }
            else
                return Unauthorized();
        }

        [HttpPost("Register")]
        public IActionResult Register(Admin a)
        {
            Admin admin = _iAdminUI.insertAdmin(a);
            if (admin != null)
            {
                admin.password = null;
                return Ok(admin);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [Authorize]
        [HttpPost("EditAdminData")]
        public IActionResult EditAdminData(Admin a)
        {
            Admin admin = _iAdminUI.editAdminData(a);
            if (admin != null)
            {
                admin.password = null;
                return Ok(admin);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }
        [Authorize]
        [HttpPost("EditAdminPassword")]
        public IActionResult EditAdminPassword(changePassword pass)
        {
            Admin admin = _iAdminUI.editAdminPassword(pass.id, pass.password.Trim(), pass.password1.Trim());
            if (admin != null)
            {
                admin.password = null;
                return Ok(admin);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [Authorize]
        [HttpPost("Delete")]
        public IActionResult DeleteAdmin(Admin admin)
        {
            bool ind = _iAdminUI.deleteAdmin(admin.id);
            if (ind == true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

        [Authorize]
        [HttpPost("EditPhoto")]
        public IActionResult EditAdminPhoto(Admin u)
        {
            Admin admin = _iAdminUI.editAdimnProfilePhoto(u.id, u.photoPath);
            if (admin != null)
            {
                return Ok(admin);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

    }
}