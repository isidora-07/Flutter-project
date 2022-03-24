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
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class UserDAL : IUserDAL
    {
        private readonly AppDbContext _context;
        private readonly AppSettings _appSettings;
        public static IWebHostEnvironment _environment;
        public UserDAL(AppDbContext context, IOptions<AppSettings> appSettings, IWebHostEnvironment environment)
        {
            _context = context;
            _appSettings = appSettings.Value;
            _environment = environment;
        }

        public List<User> getAllUsers()
        {
            return _context.user.Include(x => x.city).Include(p => p.posts).ToList();
        }

        public User getByID(long id)
        {
            return _context.user.Where((u) => u.id == id).Include(x => x.city).Include(p => p.posts).FirstOrDefault();
        }


        public User insertUser(User user)
        {
            var existInUser = _context.user.Where(x => x.email == user.email).FirstOrDefault();
            var existInAdmin = _context.admin.Where(x => x.email == user.email).FirstOrDefault();
            var existInst = _context.institution.Where(x => x.email == user.email).FirstOrDefault();
            if (existInAdmin == null && existInUser == null && existInst == null)
            {
                var existUsername = _context.user.Where(x => x.username == user.username).FirstOrDefault();
                if (existUsername == null)
                {
                    User u1 = new User();
                    u1.email = user.email;
                    u1.createdAt = DateTime.Now;
                    u1.cityId = user.cityId;
                    u1.firstName = user.firstName;
                    u1.lastName = user.lastName;
                    string newPassword = this.RandomString(6);
                    string Sha1Password = this.SHA1HashStringForUTF8String(newPassword);
                    u1.password = Sha1Password;
                    u1.phone = user.phone;
                    u1.username = user.username;
                    u1.photo = "Upload//ProfilePhoto//default.jpg";
                    u1.points = 0;
                    u1.donatedPoints = 0;
                    u1.level = 1;
                    u1.darkTheme = false;

                    _context.user.Add(u1);
                    _context.SaveChanges();
                    u1.password = newPassword;
                    return u1;
                }
                else
                {
                    return null;
                }

            }
            else
            {
                return null;
            }
        }

        public User editUserData(User user)
        {
            var exist = _context.user.Where(x => x.id == user.id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.firstName = user.firstName;
                    exist.lastName = user.lastName;
                    exist.username = user.username;
                    exist.email = user.email;
                    exist.phone = user.phone;
                    exist.cityId = user.cityId;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.user.Where(x=>x.id == user.id).Include(x=> x.city).Include(p => p.posts).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public string login(User user2)
        {
            var user = AuthenticateUser(user2);

            if (user != null)
            {
                var tokenStr = GenerateJSONWebToken(user);
                return tokenStr;
            }
            return null;
        }
        public User AuthenticateUser(User user)
        {
            var existingUser = _context.user.
                Where(k => k.email.Equals(user.email)
                    && k.password.Equals(user.password)).FirstOrDefault();
            return existingUser;
        }

        public string GenerateJSONWebToken(User user)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_appSettings.Secret));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.id.ToString()),
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

        public User editUserPassword(long id, string password, string newPassword)
        {
            var exist = _context.user.Where(x => x.id == id && x.password.Equals(password)).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    exist.password = newPassword;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.user.Where((u) => u.id == id).Include(x => x.city).Include(p => p.posts).FirstOrDefault(); ;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public bool deleteUser(long id)
        {
            var user = _context.user.Where(x => x.id == id).FirstOrDefault();
            if (user == null)
            {
                return false;
            }

            _context.user.Remove(user);
            _context.SaveChangesAsync();

            return true;
        }

        public User editUserPhoto(long id, string photoPathn)
        {
            var exist = _context.user.Where(x => x.id == id).FirstOrDefault();
            if (exist != null)
            {
                try
                {
                    if(exist.photo != "Upload//ProfilePhoto//default.jpg")
                    {
                        List<String> listStr;
                        listStr = exist.photo.Split('/').ToList();
                        var path = Path.Combine($"{_environment.ContentRootPath}/", "wwwroot/Upload/ProfilePhoto/", listStr[listStr.Count - 1]);
                        var PathWithFolder = System.IO.Path.Combine(_environment.WebRootPath, exist.photo);
                        if (System.IO.File.Exists(PathWithFolder))
                        {
                            System.IO.File.Delete(PathWithFolder);
                        }
                    }
                    exist.photo = photoPathn;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.user.Where((u) => u.id == id).Include(x => x.city).Include(p => p.posts).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public List<User> getUsersByCityId(long cityId)
        {
            return _context.user.Where(u => u.cityId == cityId).Include(x => x.city).Include(p => p.posts).ToList();
        }

        public IEnumerable<User> getNUserFromCity(long cityId, int n)
        {
            var users = _context.user.Where(u => u.cityId == cityId).Include(x => x.city).Include(p => p.posts).OrderByDescending(x => x.donatedPoints + x.points).ToList();
            return users.Take(n);
        }

        public string RandomString(int length)
        {
            Random random = new Random();
            const string pool = "abcdefghijklmnopqrstuvwxyz0123456789";
            var builder = new StringBuilder();

            for (var i = 0; i < length; i++)
            {
                var c = pool[random.Next(0, pool.Length)];
                builder.Append(c);
            }

            return builder.ToString();
        }
        public string SHA1HashStringForUTF8String(string s)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(s);

            var sha1 = SHA1.Create();
            byte[] hashBytes = sha1.ComputeHash(bytes);

            return HexStringFromBytes(hashBytes);
        }
        public string HexStringFromBytes(byte[] bytes)
        {
            var sb = new StringBuilder();
            foreach (byte b in bytes)
            {
                var hex = b.ToString("x2");
                sb.Append(hex);
            }
            return sb.ToString();
        }

        public string forgetPassword(User user)
        {
            var exist = _context.user.Where(x => x.email == user.email).FirstOrDefault();
            if (exist != null)
            {
                string newPassword = this.RandomString(6);
                string Sha1Password = this.SHA1HashStringForUTF8String(newPassword);
                exist.password = Sha1Password;
                _context.Update(exist);
                _context.SaveChanges();
                return newPassword;
            }
            else
                return null;

        }

        public User switchTheme(User user)
        {
            var user1 = _context.user.Where(x => x.id == user.id).FirstOrDefault();
            if(user1 != null)
            {
                if (user1.darkTheme)
                    user1.darkTheme = false;
                else
                    user1.darkTheme = true;
                _context.Update(user1);
                _context.SaveChanges();
                return user1;

            }
            return null;
        }
    }
}
