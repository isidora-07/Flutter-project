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
    public class AdminDAL : IAdminDAL
    {
        private readonly AppDbContext _context;
        private readonly AppSettings _appSettings;
        public static IWebHostEnvironment _environment;
        public AdminDAL(AppDbContext context, IOptions<AppSettings> appSettings, IWebHostEnvironment environment)
        {
            _context = context;
            _appSettings = appSettings.Value;
            _environment = environment;
        }

        public Admin AuthenticateAdmin(Admin admin)
        {
            var existingAdmin = _context.admin.
              Where(k => k.email.Equals(admin.email)
                  && k.password.Equals(admin.password)).FirstOrDefault();
            return existingAdmin;
        }

        public bool deleteAdmin(long id)
        {
            var adminForDel = _context.admin.Where(x => x.id == id).FirstOrDefault();
            if (adminForDel == null)
            {
                return false;
            }

            _context.admin.Remove(adminForDel);
            _context.SaveChangesAsync();

            return true;
        }

        public Admin editAdminData(Admin admin)
        {
            var exist = _context.admin.Where(x => x.id == admin.id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.firstName = admin.firstName;
                    exist.lastName = admin.lastName;
                    exist.email = admin.email;
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

        public Admin editAdminPassword(long id, string password, string newPassword)
        {
            var exist = _context.admin.Where(x => x.id == id && x.password.Equals(password)).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.password = newPassword;
                    _context.admin.Update(exist);
                    _context.SaveChanges();
                    return _context.admin.Where((u) => u.id == id).FirstOrDefault(); ;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public Admin editAdimnProfilePhoto(long id, string photoPath)
        {
            var exist = _context.admin.Where(x => x.id == id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    if (exist.photoPath != "Upload//ProfilePhoto//default.jpg")
                    {
                        List<String> listStr;
                        listStr = exist.photoPath.Split('/').ToList();
                        var path = Path.Combine($"{_environment.ContentRootPath}/", "wwwroot/Upload/InstitutionProfilePhoto/", listStr[listStr.Count - 1]);

                        if (System.IO.File.Exists(path))
                        {
                            System.IO.File.Delete(path);
                        }
                    }
                    exist.photoPath = photoPath;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.admin.Where((u) => u.id == id).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public string GenerateJSONWebToken(Admin admin)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_appSettings.Secret));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
            var x = 1;
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, admin.id.ToString()),
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

        public List<Admin> getAllAdmins()
        {
            return _context.admin.ToList();
        }

        public Admin getByID(long id)
        {
            return _context.admin.Where((u) => u.id == id).FirstOrDefault();
        }

        public Admin insertAdmin(Admin admin)
        {
            var existInUser = _context.user.Where(x => x.email == admin.email).FirstOrDefault();
            var existInAdmin = _context.admin.Where(x => x.email == admin.email).FirstOrDefault();
            var existInst = _context.institution.Where(x => x.email == admin.email).FirstOrDefault();
            if (existInAdmin == null && existInUser == null && existInst == null)
            {
                Admin a1 = new Admin();
                a1.firstName = admin.firstName;
                a1.email = admin.email;
                a1.createdAt = DateTime.Now;
                a1.lastName = admin.lastName;
                a1.password = admin.password;
                a1.photoPath = "Upload//ProfilePhoto//default.jpg";


                _context.admin.Add(a1);
                _context.SaveChanges();

                return a1;       
            }
            else
            {
                return null;
            }
        }

        public Institution AuthenticateInstitution(Admin admin)
        {
            var existingInst = _context.institution.Where(k => k.email.Equals(admin.email)
                  && k.password.Equals(admin.password) && k.authentication == true).FirstOrDefault();
            return existingInst;
        }

        public string GenerateJSONWebTokenInst(Institution inst)
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
                expires: DateTime.Now.AddDays(1),
                signingCredentials: credentials);

            var encodeToken = new JwtSecurityTokenHandler().WriteToken(token);
            return encodeToken;
        }

        public string login(Admin admin)
        {
            var adminn = AuthenticateAdmin(admin);

            if (adminn != null)
            {
                var tokenStr = GenerateJSONWebToken(adminn);
                return tokenStr;
            }
            var inst = AuthenticateInstitution(admin);
            if (inst != null)
            {
                var tokenStr = GenerateJSONWebTokenInst(inst);
                return tokenStr;
            }
            return null;
        }
    }
}
