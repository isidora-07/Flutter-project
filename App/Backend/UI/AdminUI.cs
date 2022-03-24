using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class AdminUI : IAdminUI
    {
        private readonly IAdminBL _iAdminBL;

        public AdminUI(IAdminBL iAdminBL)
        {
            _iAdminBL = iAdminBL;
        }

        public bool deleteAdmin(long id)
        {
            return _iAdminBL.deleteAdmin(id);
        }

        public Admin editAdimnProfilePhoto(long id, string photoPath)
        {
            return _iAdminBL.editAdimnProfilePhoto(id, photoPath);
        }

        public Admin editAdminData(Admin admin)
        {
            return _iAdminBL.editAdminData(admin);
        }

        public Admin editAdminPassword(long id, string password, string newPassword)
        {
            return _iAdminBL.editAdminPassword(id, password, newPassword);
        }

        public List<Admin> getAllAdmins()
        {
            return _iAdminBL.getAllAdmins();
        }

        public Admin getByID(long id)
        {
            return _iAdminBL.getByID(id);
        }

        public Admin insertAdmin(Admin admin)
        {
            return _iAdminBL.insertAdmin(admin);
        }

        public string login(Admin admin)
        {
            return _iAdminBL.login(admin);
        }
    }
}
