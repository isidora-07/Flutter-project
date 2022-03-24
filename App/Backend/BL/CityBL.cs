using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class CityBL : ICityBL
    {
        private readonly ICityDAL _iCityDAL;

        public CityBL(ICityDAL iCityDAL)
        {
            _iCityDAL = iCityDAL;
        }

        public List<City> getAllCities()
        {
            return _iCityDAL.getAllCities();
        }

        public City getByID(long id)
        {
            return _iCityDAL.getByID(id);
        }

        public City getCityFromName(string name)
        {
            return _iCityDAL.getCityFromName(name);
        }

        public City insertCity(City city)
        {
            return _iCityDAL.insertCity(city);
        }
    }
}
