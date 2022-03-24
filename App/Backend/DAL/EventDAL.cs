using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewsModel;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using static Backend.Controllers.EventController;

namespace Backend.DAL
{
    public class EventDAL : IEventDAL
    {
        private readonly AppDbContext _context;

        public EventDAL(AppDbContext context)
        {
            _context = context;
        }

        public bool addGoingToEvent1(UserEvent ue)
        {
            UserEvent eve = new UserEvent();
            UserEvent exist = null;
            if (ue.userId != null)
            {
                eve.userId = ue.userId;
                exist = _context.userEvent.Where(x => x.eventId == ue.eventId && x.userId == ue.userId).FirstOrDefault();
            }
            else if(ue.institutionId != null)
            {
                eve.institutionId = ue.institutionId;
                exist = _context.userEvent.Where(x => x.eventId == ue.eventId && x.institutionId == ue.institutionId).FirstOrDefault();
            } 
            eve.eventId = ue.eventId;
            
            if (exist != null)
            {
                _context.userEvent.Add(eve);
                _context.SaveChangesAsync();
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool addGoingToEvent(UserEvent ue)
        {
            if (ue.userId != null)
            {
                var events = _context.userEvent.Where(x => x.userId == ue.userId && x.eventId == ue.eventId).FirstOrDefault();
                if (events == null)
                {
                    UserEvent eve = new UserEvent();
                    eve.userId = ue.userId;
                    eve.eventId = ue.eventId;
                    _context.userEvent.Add(eve);
                    _context.SaveChangesAsync();
                    return true;
                }

                return false;
            }
            else if (ue.institutionId != null)
            {
                var events = _context.userEvent.Where(x => x.institutionId == ue.institutionId && x.eventId == ue.eventId).FirstOrDefault();
                if (events == null)
                {
                    UserEvent eve = new UserEvent();
                    eve.institutionId = ue.institutionId;
                    eve.eventId = ue.eventId;
                    _context.userEvent.Add(eve);
                    _context.SaveChangesAsync();
                    return true;
                }

                return false;
            }
            return false;
        }

        public bool cancelArrival(UserEvent ue)
        {
            if(ue.userId != null) 
            { 
                var events = _context.userEvent.Where(x => x.userId == ue.userId && x.eventId == ue.eventId).FirstOrDefault();
                if (events == null)
                {
                    return false;
                }

                _context.userEvent.Remove(events);
                _context.SaveChangesAsync();
                return true;
            }
            else if(ue.institutionId != null)
            {
                var events = _context.userEvent.Where(x => x.institutionId == ue.institutionId && x.eventId == ue.eventId).FirstOrDefault();
                if (events == null)
                {
                    return false;
                }

                _context.userEvent.Remove(events);
                _context.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public bool deleteEvent(long id)
        {
            var eve = _context.events.Where(x => x.id == id).FirstOrDefault();
            if (eve == null)
            {
                return false;
            }

            _context.events.Remove(eve);
            _context.SaveChangesAsync();

            return true;
        }

        public Event editEvent(EventViewModel events)
        {
            var exist = _context.events.Where(x => x.id == events.id).FirstOrDefault();
            if (exist != null)
            {
                try
                {

                    exist.description = events.description;
                    if (events.startDate != null)
                    {
                        CultureInfo enUS = new CultureInfo("en-US");
                        exist.startDate = DateTime.ParseExact(events.startDate, "M/dd/yyyy HH:mm", enUS, DateTimeStyles.None);
                    }
                    if (events.endDate != null)
                    {
                        CultureInfo enUS = new CultureInfo("en-US");
                        exist.endDate = DateTime.ParseExact(events.endDate, "M/dd/yyyy HH:mm", enUS, DateTimeStyles.None);
                    } 
                    exist.shortDescription = events.shortDescription;
                    exist.title = events.title;
                    exist.cityId = events.cityId;
                    exist.latitude = events.latitude;
                    exist.longitude = events.longitude;
                    exist.address = events.address;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.events.Where((u) => u.id == events.id).Include(x => x.institution).Include(l => l.admin).Include(c=> c.city).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public List<Event> getAllEvents()
        {
            return _context.events.Where(x => x.endDate > DateTime.Now).Include(x => x.institution).Include(l => l.admin).Include(c => c.city).OrderByDescending(x => x.startDate).ToList();
        }

        public List<Event> getAllEventsByCityId(long id)
        {
            return _context.events.Where(x => x.endDate > DateTime.Now && x.cityId == id).Include(x => x.institution).Include(l => l.admin).Include(c => c.city).OrderByDescending(x=> x.startDate).ToList();
        }

        public Event getByID(long id)
        {
            return _context.events.Where(x => x.id == id).Include(x => x.institution).Include(l => l.admin).Include(c => c.city).FirstOrDefault();
        }

        public List<Event> getFinishedEvents()
        {
            return _context.events.Where(x => x.endDate < DateTime.Now).Include(x => x.institution).Include(l => l.admin).Include(c => c.city).ToList();
        }

        public Event insertEvent(EventViewModel events)
        {
            Event eve = new Event();

            eve.cityId = events.cityId;
            eve.adminId = events.adminId;
            eve.institutionId = events.institutionId;
            eve.latitude = events.latitude;
            eve.longitude = events.longitude;
            eve.shortDescription = events.shortDescription;
            CultureInfo enUS = new CultureInfo("en-US");
            eve.startDate = DateTime.ParseExact(events.startDate, "M/dd/yyyy HH:mm", enUS, DateTimeStyles.None);
            eve.endDate = DateTime.ParseExact(events.endDate, "M/dd/yyyy HH:mm", enUS, DateTimeStyles.None);
            eve.address = events.address;
            eve.description = events.description;
            eve.title = events.title;
            if (eve != null)
            {
                _context.events.Add(eve);
                _context.SaveChangesAsync();
                return eve;
            }
            else
            {
                return null;
            }
        }

        public List<UserEvent> institutionsGoingToEvent(long eventId)
        {
            return _context.userEvent.Where(x => x.eventId == eventId && x.institutionId != null).Include(u => u.user).Include(u => u.institution).ToList();

        }

        public List<UserEvent> usersGoingToEvent(long eventId)
        {
            return _context.userEvent.Where(x => x.eventId == eventId && x.userId != null).Include(u => u.user).Include(u => u.institution).ToList();
        }
    }
}
