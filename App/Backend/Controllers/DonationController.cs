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
    public class DonationController : ControllerBase
    {
        private readonly IDonationUI _iDonationUI;

        public DonationController(IDonationUI iDonationUI)
        {
            _iDonationUI = iDonationUI;
        }


        [Authorize]
        [HttpGet]
        public ActionResult<IEnumerable<DonationViewModel>> GetDonation()
        {
            var donations = _iDonationUI.getAllDonations();
            List<DonationViewModel> listDonation = new List<DonationViewModel>();
            foreach (var don in donations)
            {
                listDonation.Add(new DonationViewModel(don));
            }
            return listDonation;
        }

        [Authorize]
        [HttpGet("getById={id}")]
        public ActionResult<DonationViewModel> GetById(int id)
        {
            Donation donat = _iDonationUI.getByID(id);
            DonationViewModel fullDonation = new DonationViewModel(donat);
            return fullDonation;
        }

        [Authorize]
        [HttpGet("GetLastDonation")]
        public ActionResult<DonationViewModel> GetLastDonation()
        {
            Donation donat = _iDonationUI.getLastDonation();
            DonationViewModel fullDonation = new DonationViewModel(donat);
            return fullDonation;
        }

        [Authorize]
        [HttpGet("FinishedDonation")]
        public ActionResult<IEnumerable<DonationViewModel>> GetFinishedDonation()
        {
            var donations = _iDonationUI.getFinishedDonations();
            List<DonationViewModel> listDonation = new List<DonationViewModel>();
            foreach (var don in donations)
            {
                listDonation.Add(new DonationViewModel(don));
            }
            return listDonation;
        }

        [Authorize]
        [HttpPost]
        public IActionResult InsertDonation(Donation donation)
        {
            Donation d = _iDonationUI.insertDonation(donation);
            if (d != null)
            {
                return Ok(d);
            }
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("editDonation")]
        public IActionResult EditDonation(Donation don)
        {
            Donation d = _iDonationUI.editDonation(don);
            if (d != null)
            {
                DonationViewModel donation1 = new DonationViewModel(d);
                return Ok(donation1);
            }
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("Delete")]
        public IActionResult DeleteDonation(Donation don)
        {
            bool ind = _iDonationUI.deleteDonation(don.id);
            if (ind == true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

        [Authorize]
        [HttpPost("UserForDonation")]
        public IEnumerable<User> UserForDonatin(Donation don)
        {
            var users = _iDonationUI.usersWhoParcipate(don.id);
            List<User> listUsers = new List<User>();
            foreach (var u in users)
            {
                User user = u.user;
                user.password = null;
                user.points = u.donatedPoints;
                listUsers.Add(user);

            }
            return listUsers;
        }

        [Authorize]
        [HttpPost("addParcipate")]
        public IActionResult AddParticipate(UserDonation donation)
        {
            Donation don = _iDonationUI.addParticipate(donation);
            if (don != null)
            {
                DonationViewModel fullDonation = new DonationViewModel(don);
                return Ok(fullDonation);
            }
            else
                return BadRequest(new { message = "Greska" });
        }
    }
}