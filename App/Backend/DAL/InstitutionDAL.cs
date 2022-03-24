using Backend.DAL.Interfaces;
using Backend.Helpers;
using Backend.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class InstitutionDAL : IInstitutionDAL
    {
        private readonly AppDbContext _context;
        private readonly AppSettings _appSettings;
        public static IWebHostEnvironment _environment;

        public InstitutionDAL(AppDbContext context, IOptions<AppSettings> appSettings, IWebHostEnvironment environment)
        {
            _context = context;
            _appSettings = appSettings.Value;
            _environment = environment;
        }

        public Institution acceptInstitution(long id)
        {
            var exist = _context.institution.Where(x => x.id == id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.authentication = true;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return exist;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public Institution AuthenticateInstitucion(Institution inst)
        {
            var existingInst = _context.institution.
                Where(k => k.email.Equals(inst.email)
                    && k.password.Equals(inst.password) && k.authentication == true).FirstOrDefault();
            return existingInst;
        }

        public bool deleteInstitution(long id)
        {
            var inst = _context.institution.Where(x => x.id == id).FirstOrDefault();
            if (inst == null)
            {
                return false;
            }

            _context.institution.Remove(inst);
            _context.SaveChangesAsync();

            return true;
        }

        public Institution editData(Institution inst)
        {
            var exist = _context.institution.Where(x => x.id == inst.id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.name = inst.name;
                    exist.email = inst.email;
                    exist.phone = inst.phone;
                    exist.description = inst.description;
                    exist.cityId = inst.cityId;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return exist;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public Institution editPassword(long id, string password, string newPassword)
        {
            var exist = _context.institution.Where(x => x.id == id && x.password.Equals(password)).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.password = newPassword;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.institution.Where((u) => u.id == id).Include(x => x.city).FirstOrDefault(); ;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public string GenerateJSONWebToken(Institution inst)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_appSettings.Secret));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
            var x = 2;
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, inst.id.ToString()),
                new Claim(JwtRegisteredClaimNames.NameId, x.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti,Guid.NewGuid().ToString())
            };

            var token = new JwtSecurityToken(
                issuer: _appSettings.Secret,
                audience: _appSettings.Secret,
                claims,
                expires: DateTime.Now.AddDays(30),
                signingCredentials: credentials);

            var encodeToken = new JwtSecurityTokenHandler().WriteToken(token);
            return encodeToken;
        }

        public List<Institution> getAllAuthInstitutions()
        {
            return _context.institution.Where(x => x.authentication == true).Include(x => x.city).ToList();
        }

        public Institution getByID(long id)
        {
            return _context.institution.Where(x => x.id == id).Include(x=>x.city).FirstOrDefault();
        }

        public List<Institution> getAuthInstitutionByCityId(long cityId)
        {
            return _context.institution.Where(x => x.cityId == cityId && x.authentication == true).Include(x=>x.city).ToList();
        }
        public List<Institution> getUnauthInstitutionByCityId(long cityId)
        {
            return _context.institution.Where(x => x.cityId == cityId && x.authentication == false).Include(x => x.city).ToList();
        }

        public Institution insertInstitution(Institution inst)
        {
            var existInUser = _context.user.Where(x => x.email == inst.email).FirstOrDefault();
            var existInAdmin = _context.admin.Where(x => x.email == inst.email).FirstOrDefault();
            var existInst = _context.institution.Where(x => x.email == inst.email).FirstOrDefault();
            if (existInAdmin == null && existInUser == null && existInst == null)
            {
             
                Institution u1 = new Institution();
                u1.createdAt = DateTime.Now;
                u1.name = inst.name;
                u1.password = inst.password;
                u1.phone = inst.phone;
                u1.email = inst.email;
                u1.description = inst.description;
                u1.cityId = inst.cityId;
                u1.authentication = false;
                u1.photoPath = "Upload//ProfilePhoto//default.jpg";


                _context.institution.Add(u1);
                _context.SaveChanges();

                return u1;
              
            }
            else
            {
                return null;
            }
        }

        public string login(Institution institution)
        {
            var inst = AuthenticateInstitucion(institution);

            if (inst != null)
            {
                var tokenStr = GenerateJSONWebToken(inst);
                return tokenStr;
            }
            return null;
        }

        public List<Institution> getAllUnauthInstitutions()
        {
            return _context.institution.Where(x => x.authentication == false).Include(x => x.city).ToList();
        }

        public Institution editInstitutionProfilePhoto(long id, string photoPath)
        {
            var exist = _context.institution.Where(x => x.id == id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    if (exist.photoPath != "Upload//ProfilePhoto//default.jpg")
                    {
                        List<String> listStr;
                        listStr = exist.photoPath.Split('/').ToList();
                        var path = Path.Combine($"{_environment.ContentRootPath}/", "wwwroot/Upload/InstitutionProfilePhoto/", listStr[listStr.Count - 1]);
                        var PathWithFolder = System.IO.Path.Combine(_environment.WebRootPath, exist.photoPath);
                        if (System.IO.File.Exists(PathWithFolder))
                        {
                            System.IO.File.Delete(PathWithFolder);
                        }
                    }
                    exist.photoPath = photoPath;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.institution.Where((u) => u.id == id).Include(x => x.city).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }
    }
}
