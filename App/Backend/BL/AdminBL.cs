using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class AdminBL : IAdminBL
    {
        private readonly IAdminDAL _iAdminDAL;

        public AdminBL(IAdminDAL iAdminDAL)
        {
            _iAdminDAL = iAdminDAL;
        }

        public bool deleteAdmin(long id)
        {
            return _iAdminDAL.deleteAdmin(id);
        }

        public Admin editAdimnProfilePhoto(long id, string photoPath)
        {
            return _iAdminDAL.editAdimnProfilePhoto(id, photoPath);
        }

        public Admin editAdminData(Admin admin)
        {
            return _iAdminDAL.editAdminData(admin);
        }

        public Admin editAdminPassword(long id, string password, string newPassword)
        {
            return _iAdminDAL.editAdminPassword(id, password, newPassword);
        }

        public List<Admin> getAllAdmins()
        {
            return _iAdminDAL.getAllAdmins();
        }

        public Admin getByID(long id)
        {
            return _iAdminDAL.getByID(id);
        }

        public Admin insertAdmin(Admin admin)
        {
            return _iAdminDAL.insertAdmin(admin);
        }

        public string login(Admin admin)
        {
            return _iAdminDAL.login(admin);
        }
    }
}
