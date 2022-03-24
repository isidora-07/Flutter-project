using Backend.Models;
using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static Backend.Controllers.EventController;

namespace Backend.UI.Interfaces
{
    public interface IEventUI
    {
        List<Event> getAllEvents();
        List<Event> getFinishedEvents();
        List<Event> getAllEventsByCityId(long id);
        bool addGoingToEvent(UserEvent ue);
        Event getByID(long id);
        Event insertEvent(EventViewModel events);
        bool deleteEvent(long id);
        Event editEvent(EventViewModel events);
        List<UserEvent> usersGoingToEvent(long eventId);
        List<UserEvent> institutionsGoingToEvent(long eventId);
        bool cancelArrival(UserEvent ue);
    }
}
