using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IUserBL
    {
        List<User> getAllUsers();
        User getByID(long id);
        User insertUser(User user);
        string login(User user);
        User editUserData(User user);
        User switchTheme(User user);
        User editUserPassword(long id, string password, string newPassword);
        bool deleteUser(long id);
        User editUserPhoto(long id, string photoPathn);
        List<User> getUsersByCityId(long cityId);
        IEnumerable<User> getNUserFromCity(long cityId, int n);
        string forgetPassword(User user);
    }
}
