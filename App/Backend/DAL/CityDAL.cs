using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class CityDAL : ICityDAL
    {
        private readonly AppDbContext _context;

        public CityDAL(AppDbContext context)
        {
            _context = context;
        }

        public City insertCity(City city)
        {
            City city1 = new City();
            city1.name = city.name;
            city1.latitude = city.latitude;
            city1.longitude = city.longitude;

            if (city1 != null)
            {
                _context.city.Add(city1);
                _context.SaveChangesAsync();
                return city1;
            }
            else
            {
                return null;
            }
        }

        public List<City> getAllCities()
        {
            return _context.city.ToList();
        }

        public City getByID(long id)
        {
            return _context.city.Where(c => c.id == id).FirstOrDefault();
        }

        public City getCityFromName(string name)
        {
            string latName = this.Translit(name);
            latName = latName.Trim();
            var city = _context.city.Where(x => x.name.Equals(latName)).FirstOrDefault();
            if(city != null)
            {
                return city;
            }
            return null;

        }

        public string Translit(string str)
        {
            string[] lat_up = { "A", "B", "V", "G", "Dž", "D", "Đ", "E", "Ž", "Z", "I", "J", "K", "Lj", "L", "M", "Nj" ,"N", "O", "P", "R", "S", "T", "Ć", "U", "F", "H", "C", "Č", "Š" };
            string[] lat_low = { "a", "b", "v", "g", "dž", "d", "đ", "e", "ž", "z", "i", "j", "k", "lj", "l", "m", "nj", "n", "o", "p", "r", "s", "t", "ć", "u", "f", "h", "c", "č", "š" };
            string[] rus_up = { "А", "Б", "В", "Г", "Џ", "Д", "Ђ", "Е", "Ж", "З", "И", "Ј", "К", "Љ", "Л", "М", "Њ", "Н", "О", "П", "Р", "С", "Т", "Ћ", "У", "Ф", "Х", "Ц", "Ч", "Ш" };
            string[] rus_low = { "а", "б", "в", "г", "џ", "д", "ђ", "е", "ж", "з", "и", "ј", "к", "љ", "л", "м", "њ", "н", "о", "п", "р", "с", "т", "ћ", "у", "ф", "х", "ц", "ч", "ш" };
            for (int i = 0; i < lat_up.Length; i++)
            {
                str = str.Replace(rus_up[i], lat_up[i]);
                str = str.Replace(rus_low[i], lat_low[i]);
            }
            return str;
        }
    }
}
