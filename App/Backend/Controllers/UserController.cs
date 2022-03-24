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
using MimeKit;
using MailKit.Net.Smtp;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserUI _iUserUI;

        public UserController(IUserUI iUserUI)
        {
            _iUserUI = iUserUI;
        }

        [Authorize]
        [HttpGet]
        public IEnumerable<UserViewModel> GetUsers()
        {
            var users = _iUserUI.getAllUsers();
            List<UserViewModel> user = new List<UserViewModel>();
            foreach (var u in users)
            {
                user.Add(new UserViewModel(u));
            }

            return user;

        }

        [Authorize]
        [HttpGet("{id}")]
        public UserViewModel GetUser(long id)
        {
            var user = _iUserUI.getByID(id);
            if(user != null)
            { 
                UserViewModel userr = new UserViewModel(user);
                return userr;
            }
            return null;

        }

        [HttpPost("Login")]
        public IActionResult Login([FromBody] User userParam)
        {
            string tokenStr = _iUserUI.login(userParam);
            if (tokenStr != null)
            {
                return Ok(new { token = tokenStr });
            }
            else
                return Unauthorized();
        }

        [HttpPost("Register")]
        public IActionResult Register(User u)
        {
            User user = _iUserUI.insertUser(u);
            if (user != null)
            {
              
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("Moj grad", "mojgrad.info@gmail.com"));
                message.To.Add(new MailboxAddress("Moj grad", u.email));
                message.Subject = "Moj grad";
                message.Body = new TextPart("plain")
                {
                    Text = "Uspešno ste aktivirali nalog na aplikaciji MOJ GRAD. Možete se prijaviti sa podacima:\nusername: "+user.username+ "\nlozinka: " + user.password + "\n\nPredlažemo da nakon prijave promenite šifru."
                };
                using (var client = new SmtpClient())
                {
                    client.Connect("smtp.gmail.com", 587, false);
                    client.Authenticate("mojgrad.info@gmail.com", "MojGrad22");
                    client.Send(message);

                    client.Disconnect(true);
                }
                user.password = null;
                return Ok(user);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [HttpPost("ForgetPassword")]
        public IActionResult ForgetPassword(User u)
        {
            string password = _iUserUI.forgetPassword(u);
            if (password != null)
            {
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("Moj grad", "mojgrad.info@gmail.com"));
                message.To.Add(new MailboxAddress("Moj grad", u.email));
                message.Subject = "Moj grad";
                message.Body = new TextPart("plain")
                {
                    Text = "Vaša šifra je uspešno promenjena. Nova šifra Vašeg naloga je " + password + "\nPredlažemo da nakon prijave promenite šifru."
                };
                using (var client = new SmtpClient())
                {
                    client.Connect("smtp.gmail.com", 587, false);
                    client.Authenticate("mojgrad.info@gmail.com", "MojGrad22");
                    client.Send(message);

                    client.Disconnect(true);
                }
                return Ok("sifra promenjena");
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [Authorize]
        [HttpPost("EditUserData")]
        public IActionResult EditUserData(User u)
        {
            User user = _iUserUI.editUserData(u);
            if (user != null)
            {
                user.password = null;
                UserViewModel user1 = new UserViewModel(user);
                return Ok(user1);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }
        public class changePassword
        {
            public long id { get; set; }
            public string password { get; set; }
            public string password1 { get; set; }
        }

        [Authorize]
        [HttpPost("EditUserPassword")]
        public IActionResult EditUserPassword(changePassword pass)
        {
            User user = _iUserUI.editUserPassword(pass.id, pass.password ,pass.password1);
            if (user != null)
            {
                user.password = null;
                return Ok(user);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }
        public class deleteUser
        {
            public long id { get; set; }
        }
        [Authorize]
        [HttpPost("Delete")]
        public IActionResult DeleteUser(deleteUser user)
        {
            bool ind = _iUserUI.deleteUser(user.id);
            if (ind ==true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

        [Authorize]
        [HttpPost("EditUserPhoto")]
        public IActionResult EditUserPhoto(User u)
        {
            User user = _iUserUI.editUserPhoto(u.id, u.photo);
            if (user != null)
            {
                UserViewModel newUser = new UserViewModel(user);
                return Ok(newUser);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [Authorize]
        [HttpPost("UsersByCityId")]
        public IEnumerable<UserViewModel> GetUsersByCityId(User user1)
        {
            var users = _iUserUI.getUsersByCityId(user1.cityId);
            List<UserViewModel> user = new List<UserViewModel>();
            foreach (var u in users)
            {
                user.Add(new UserViewModel(u));
            }

            return user;

        }

        [Authorize]
        [HttpPost("Top10")]
        public IEnumerable<UserViewModel> GetTop10UsersByCityId(User user1)
        {
            var users = _iUserUI.getTop10UserFromCity(user1.cityId);
            List<UserViewModel> user = new List<UserViewModel>();
            foreach (var u in users)
            {
                user.Add(new UserViewModel(u));
            }

            return user;

        }

        [Authorize]
        [HttpPost("SwitchTheme")]
        public IActionResult SwitchTheme(User u)
        {
            User user = _iUserUI.switchTheme(u);
            if (user != null)
            {
                user.password = null;
                return Ok(user);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

    }
}