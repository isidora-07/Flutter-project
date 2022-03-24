using Backend.Models;
using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static Backend.Controllers.EventController;

namespace Backend.DAL.Interfaces
{
    public interface IEventDAL
    {
        List<Event> getAllEvents();
        List<Event> getFinishedEvents();
        bool addGoingToEvent(UserEvent ue);
        List<Event> getAllEventsByCityId(long id);
        Event getByID(long id);
        Event insertEvent(EventViewModel events);
        bool deleteEvent(long id);
        Event editEvent(EventViewModel events);
        List<UserEvent> usersGoingToEvent(long eventId);
        List<UserEvent> institutionsGoingToEvent(long eventId);
        bool cancelArrival(UserEvent ue);
    }
}
