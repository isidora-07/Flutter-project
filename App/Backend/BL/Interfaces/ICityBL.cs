using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface ICityBL
    {
        List<City> getAllCities();
        City getByID(long id);
        City insertCity(City city);
        City getCityFromName(string name);
    }
}
