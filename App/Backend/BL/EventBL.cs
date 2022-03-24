using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static Backend.Controllers.EventController;

namespace Backend.BL
{
    public class EventBL :IEventBL
    {
        private readonly IEventDAL _iEventDAL;

        public EventBL(IEventDAL iEventDAL)
        {
            _iEventDAL = iEventDAL;
        }

        public bool addGoingToEvent(UserEvent ue)
        {
            return _iEventDAL.addGoingToEvent(ue);
        }

        public bool cancelArrival(UserEvent ue)
        {
            return _iEventDAL.cancelArrival(ue);
        }

        public bool deleteEvent(long id)
        {
            return _iEventDAL.deleteEvent(id);
        }

        public Event editEvent(EventViewModel events)
        {
            return _iEventDAL.editEvent(events);
        }

        public List<Event> getAllEvents()
        {
            return _iEventDAL.getAllEvents();
        }

        public List<Event> getAllEventsByCityId(long id)
        {
            return _iEventDAL.getAllEventsByCityId(id);
        }

        public Event getByID(long id)
        {
            return _iEventDAL.getByID(id);
        }

        public List<Event> getFinishedEvents()
        {
            return _iEventDAL.getFinishedEvents();
        }

        public Event insertEvent(EventViewModel events)
        {
            return _iEventDAL.insertEvent(events);
        }

        public List<UserEvent> institutionsGoingToEvent(long eventId)
        {
            return _iEventDAL.institutionsGoingToEvent(eventId);
        }

        public List<UserEvent> usersGoingToEvent(long eventId)
        {
            return _iEventDAL.usersGoingToEvent(eventId);
        }
    }
}
