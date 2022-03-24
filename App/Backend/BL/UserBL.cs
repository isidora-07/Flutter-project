using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class UserBL : IUserBL
    {
        private readonly IUserDAL _iUserDAL;

        public UserBL(IUserDAL iUserDAL)
        {
            _iUserDAL = iUserDAL;
        }

        public bool deleteUser(long id)
        {
            return _iUserDAL.deleteUser(id);
        }

        public User editUserData(User user)
        {
            return _iUserDAL.editUserData(user);
        }

        public User editUserPassword(long id, string password, string newPassword)
        {
            return _iUserDAL.editUserPassword(id,password, newPassword);
        }

        public User editUserPhoto(long id, string photoPathn)
        {
            return _iUserDAL.editUserPhoto(id, photoPathn);
        }

        public string forgetPassword(User user)
        {
            return _iUserDAL.forgetPassword(user);
        }

        public List<User> getAllUsers()
        {
            return _iUserDAL.getAllUsers();
        }

        public User getByID(long id)
        {
            return _iUserDAL.getByID(id);
        }

        public IEnumerable<User> getNUserFromCity(long cityId, int n)
        {
            return _iUserDAL.getNUserFromCity(cityId, n);
        }

        public List<User> getUsersByCityId(long cityId)
        {
            return _iUserDAL.getUsersByCityId(cityId);
        }

        public User insertUser(User user)
        {
            return _iUserDAL.insertUser(user);
        }

        public string login(User user)
        {
            return _iUserDAL.login(user);
        }

        public User switchTheme(User user)
        {
            return _iUserDAL.switchTheme(user);
        }
    }
}
