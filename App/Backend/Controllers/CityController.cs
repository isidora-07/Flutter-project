using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CityController : ControllerBase
    {
        private readonly ICityUI _iCityUI;

        public CityController(ICityUI iCityUI)
        {
            _iCityUI = iCityUI;
        }

        [HttpGet]
        public ActionResult<IEnumerable<City>> GetCity()
        {
            return  _iCityUI.getAllCities();
        }

        [HttpGet("{id}")]
        public City GetCityById(long id)
        {
            var city = _iCityUI.getByID(id);
            return city;
        }

        [Authorize]
        [HttpPost]
        public IActionResult InsertCity(City city1)
        {
            var city = _iCityUI.insertCity(city1);
            if(city != null)
            {
                return Ok(city);
            }
            return BadRequest("unos nije uspeo");

        }

        [HttpPost]
        [HttpPost("GetCityFromName")]
        public IActionResult getCityFromName(City city1)
        {
            var city = _iCityUI.getCityFromName(city1.name);
            if (city != null)
            {
                return Ok(city);
            }
            return BadRequest("Grad nije u bazi");

        }

    }
}