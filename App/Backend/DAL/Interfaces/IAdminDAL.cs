using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IAdminDAL
    {
        List<Admin> getAllAdmins();
        Admin getByID(long id);
        Admin insertAdmin(Admin admin);
        string login(Admin admin);
        Admin editAdminData(Admin admin);
        Admin editAdimnProfilePhoto(long id, string photoPath);
        Admin editAdminPassword(long id, string password, string newPassword);
        bool deleteAdmin(long id);
        public string GenerateJSONWebToken(Admin admin);
        public Admin AuthenticateAdmin(Admin admin);
    }
}
