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
    public class EventController : ControllerBase
    {
        private readonly IEventUI _iEventUI;

        public EventController(IEventUI iEventUI)
        {
            _iEventUI = iEventUI;
        }

        [Authorize]
        [HttpGet("userId={userID}")]
        public ActionResult<IEnumerable<EventViewModel>> GetAllEvents(int userId)
        {
            var events = _iEventUI.getAllEvents();
            List<EventViewModel> listEvents = new List<EventViewModel>();
            foreach (var eve in events)
            {
                listEvents.Add(new EventViewModel(eve, userId, null));
            }

            return listEvents;
        }

        [Authorize]
        [HttpGet("ForWeb/instId={instId}")]
        public ActionResult<IEnumerable<EventViewModel>> GetAllEventsForWeb(int instId)
        {
            var events = _iEventUI.getAllEvents();
            List<EventViewModel> listEvents = new List<EventViewModel>();
            foreach (var eve in events)
            {
                listEvents.Add(new EventViewModel(eve, null, instId));
            }

            return listEvents;
        }

        [Authorize]
        [HttpGet("FinishedEvent")]
        public ActionResult<IEnumerable<EventViewModel>> GetFinishedEvents()
        {
            var events = _iEventUI.getFinishedEvents();
            List<EventViewModel> listEvents = new List<EventViewModel>();
            foreach (var eve in events)
            {
                listEvents.Add(new EventViewModel(eve, 0, null));
            }

            return listEvents;
        }

        [Authorize]
        [HttpGet("byCityId={cityId}/userId={userId}")]
        public ActionResult<IEnumerable<EventViewModel>> GetFromCityId(int cityId,int userId)
        {
            var events = _iEventUI.getAllEventsByCityId(cityId);
            List<EventViewModel> listEvents = new List<EventViewModel>();
            foreach (var eve in events)
            {
                listEvents.Add(new EventViewModel(eve, userId, null));
            }

            return listEvents;
        }

        [Authorize]
        [HttpGet("ByCityForWeb/cityId={cityId}/instId={instId}")]
        public ActionResult<IEnumerable<EventViewModel>> GetFromCityIdForWeb(int cityId, int instId)
        {
            var events = _iEventUI.getAllEventsByCityId(cityId);
            List<EventViewModel> listEvents = new List<EventViewModel>();
            foreach (var eve in events)
            {
                listEvents.Add(new EventViewModel(eve, null, instId));
            }

            return listEvents;
        }

        [Authorize]
        [HttpGet("getById={id}/userId={userID}")]
        public ActionResult<EventViewModel> GetById(int id, int userId)
        {
            Event events = _iEventUI.getByID(id);
            EventViewModel fullEvent = new EventViewModel(events, userId, null);
            return fullEvent;
        }

        [Authorize]
        [HttpGet("ByIdForWeb/id={id}/instId={instId}")]
        public ActionResult<EventViewModel> GetByIdForWeb(int id, int instId)
        {
            Event events = _iEventUI.getByID(id);
            EventViewModel fullEvent = new EventViewModel(events, null, instId);
            return fullEvent;
        }

        [Authorize]
        [HttpPost]
        public IActionResult InsertEvent(EventViewModel events)
        {
            Event e = _iEventUI.insertEvent(events);
            if (e != null)
            {
                return Ok(e);
            }
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("editEvent")]
        public IActionResult EditEvent(EventViewModel eve)
        {
            Event e = _iEventUI.editEvent(eve);
            if (e != null)
            {
                EventViewModel event1 = new EventViewModel(e, null, null);
                return Ok(event1);
            }
            else
                return BadRequest(new { message = "Unos nije uspeo" });
        }

        [Authorize]
        [HttpPost("Delete")]
        public IActionResult DeleteEvent(Event eve)
        {
            bool ind = _iEventUI.deleteEvent(eve.id);
            if (ind == true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

        [Authorize]
        [HttpPost("UserForEvent")]
        public IEnumerable<User> UserForEvents(Event events)
        {
            var users = _iEventUI.usersGoingToEvent(events.id);
            List<User> listUsers = new List<User>();
            foreach(var u in users)
            {
                User user = u.user;
                user.password = null;
                listUsers.Add(user);

            }
            return listUsers;
        }

        [Authorize]
        [HttpPost("addGoingToEvent")]
        public IActionResult AddGoingToEvent(UserEvent events)
        {
            bool ind = _iEventUI.addGoingToEvent(events);
            if (ind == true)
            {
                return Ok(new { message = "Uspesno dodato" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

        [Authorize]
        [HttpPost("CancelArrival")]
        public IActionResult CancelArrivalToEvent(UserEvent eve)
        {
            bool ind = _iEventUI.cancelArrival(eve);
            if (ind == true)
            {
                return Ok(new { message = "Obrisan" });
            }
            else
                return BadRequest(new { message = "Greska" });
        }

        [Authorize]
        [HttpPost("InstitutionsForEvent")]
        public IEnumerable<Institution> InstitutionsForEvents(Event events)
        {
            var institutions = _iEventUI.institutionsGoingToEvent(events.id);
            List<Institution> listInstitutions = new List<Institution>();
            foreach (var inst in institutions)
            {
                Institution institution = inst.institution;
                institution.password = null;
                listInstitutions.Add(institution);

            }
            return listInstitutions;
        }
    }
}