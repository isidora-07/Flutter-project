using Backend.BL.Interfaces;
using Backend.Models;
using Backend.Models.ViewsModel;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static Backend.Controllers.EventController;

namespace Backend.UI
{
    public class EventUI :IEventUI
    {
        private readonly IEventBL _iEventBL;

        public EventUI(IEventBL iEventBL)
        {
            _iEventBL = iEventBL;
        }

        public bool addGoingToEvent(UserEvent ue)
        {
            return _iEventBL.addGoingToEvent(ue);
        }

        public bool cancelArrival(UserEvent ue)
        {
            return _iEventBL.cancelArrival(ue);
        }

        public bool deleteEvent(long id)
        {
            return _iEventBL.deleteEvent(id);
        }

        public Event editEvent(EventViewModel events)
        {
            return _iEventBL.editEvent(events);
        }

        public List<Event> getAllEvents()
        {
            return _iEventBL.getAllEvents();
        }

        public List<Event> getAllEventsByCityId(long id)
        {
            return _iEventBL.getAllEventsByCityId(id);
        }

        public Event getByID(long id)
        {
            return _iEventBL.getByID(id);
        }

        public List<Event> getFinishedEvents()
        {
            return _iEventBL.getFinishedEvents();
        }

        public Event insertEvent(EventViewModel events)
        {
            return _iEventBL.insertEvent(events);
        }

        public List<UserEvent> institutionsGoingToEvent(long eventId)
        {
            return _iEventBL.institutionsGoingToEvent(eventId);
        }

        public List<UserEvent> usersGoingToEvent(long eventId)
        {
            return _iEventBL.usersGoingToEvent(eventId);
        }
    }
}
