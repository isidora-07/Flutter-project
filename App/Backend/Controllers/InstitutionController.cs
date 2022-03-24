using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MimeKit;
using static Backend.Controllers.UserController;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InstitutionController : ControllerBase
    {
        private readonly IInstitutionUI _iInstitutionUI;

        public InstitutionController(IInstitutionUI iInstitutionUI)
        {
            _iInstitutionUI = iInstitutionUI;
        }

        [Authorize]
        [HttpGet]
        public IEnumerable<InstitutionViewModel> GetAuthInstitution()
        {
            var users = _iInstitutionUI.getAllAuthInstitutions();
            List<InstitutionViewModel> user = new List<InstitutionViewModel>();
            foreach (var u in users)
            {
                user.Add(new InstitutionViewModel(u));
            }

            return user;
        }

        [Authorize]
        [HttpGet("Unauthorized")]
        public IEnumerable<InstitutionViewModel> getAllUnauthInstitutions()
        {
            var users = _iInstitutionUI.getAllUnauthInstitutions();
            List<InstitutionViewModel> user = new List<InstitutionViewModel>();
            foreach (var u in users)
            {
                user.Add(new InstitutionViewModel(u));
            }
            return user;
        }

        [Authorize]
        [HttpGet("{id}")]
        public InstitutionViewModel GetInstitution(long id)
        {
            var inst = _iInstitutionUI.getByID(id);
            InstitutionViewModel instt = new InstitutionViewModel(inst);
            return instt;

        }

        [HttpPost("Login")]
        public IActionResult Login([FromBody] Institution instParam)
        {
            string tokenStr = _iInstitutionUI.login(instParam);
            if (tokenStr != null)
            {
                return Ok(new { token = tokenStr });
            }
            else
                return Unauthorized();
        }

        [HttpPost("Register")]
        public IActionResult Register(Institution u)
        {
            Institution inst = _iInstitutionUI.insertInstitution(u);
            if (inst != null)
            {
                inst.password = null;
                return Ok(inst);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [Authorize]
        [HttpPost("EditData")]
        public IActionResult EditData(Institution u)
        {
            Institution inst = _iInstitutionUI.editData(u);
            if (inst != null)
            {
                inst.password = null;
                return Ok(inst);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }

        [Authorize]
        [HttpPost("EditPassword")]
        public IActionResult EditUserPassword(changePassword pass)
        {
            Institution inst = _iInstitutionUI.editPassword(pass.id, pass.password, pass.password1);
            if (inst != null)
            {
                inst.password = null;
                return Ok(inst);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }
        [Authorize]
        [HttpPost("Delete")]
        public IActionResult DeleteInstitution(Institution inst)
        {
            bool ind = _iInstitutionUI.deleteInstitution(inst.id);
            if (ind == true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }
        [Authorize]
        [HttpPost("AcceptInstitution")]
        public IActionResult AcceptInstitution(Institution inst)
        {
            Institution ind = _iInstitutionUI.acceptInstitution(inst.id);
            if (ind != null)
            {
                
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("Moj grad", "mojgrad.info@gmail.com"));
                message.To.Add(new MailboxAddress("Moj grad", inst.email));
                message.Subject = "Moj grad";
                message.Body = new TextPart("plain")
                {
                    Text = "Zahtev je prihvaćen. Hvala na angažovanju"
                };
                using (var client = new SmtpClient())
                {
                    client.Connect("smtp.gmail.com", 587, false);
                    client.Authenticate("mojgrad.info@gmail.com", "MojGrad22");
                    client.Send(message);

                    client.Disconnect(true);
                }
                
                return Ok(new { message = "Prihvacena" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

        [Authorize]
        [HttpPost("AuthorizedByCityId")]
        public IEnumerable<InstitutionViewModel> GetAuthorizedByCityId(User user1)
        {
            var inst = _iInstitutionUI.getAuthInstitutionByCityId(user1.cityId);
            List<InstitutionViewModel> user = new List<InstitutionViewModel>();
            foreach (var u in inst)
            {
                user.Add(new InstitutionViewModel(u));
            }
            return user;
        }

        [Authorize]
        [HttpPost("UnauthorizedByCityId")]
        public IEnumerable<InstitutionViewModel> GetUnauthorizedByCityId(User user1)
        {
            var inst = _iInstitutionUI.getUnauthInstitutionByCityId(user1.cityId);
            List<InstitutionViewModel> user = new List<InstitutionViewModel>();
            foreach (var u in inst)
            {
                user.Add(new InstitutionViewModel(u));
            }
            return user;
        }

        [Authorize]
        [HttpPost("EditProfilePhoto")]
        public IActionResult EditProfilePhoto(Institution u)
        {
            Institution institution = _iInstitutionUI.editInstitutionProfilePhoto(u.id, u.photoPath);
            if (institution != null)
            {
                InstitutionViewModel newInst = new InstitutionViewModel(institution);
                return Ok(newInst);
            }
            else
                return BadRequest(new { message = "Nevalidni podaci" });
        }
    }
}