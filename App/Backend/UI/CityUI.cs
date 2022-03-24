using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class CityUI : ICityUI
    {
        private readonly ICityBL _iCityBL;

        public CityUI(ICityBL iCityBL)
        {
            _iCityBL = iCityBL;
        }

        public List<City> getAllCities()
        {
            return _iCityBL.getAllCities();
        }

        public City getByID(long id)
        {
            return _iCityBL.getByID(id);
        }

        public City getCityFromName(string name)
        {
            return _iCityBL.getCityFromName(name);
        }

        public City insertCity(City city)
        {
            return _iCityBL.insertCity(city);
        }
    }
}
