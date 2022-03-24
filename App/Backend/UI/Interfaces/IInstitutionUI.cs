using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IInstitutionUI
    {
        List<Institution> getAllAuthInstitutions();
        List<Institution> getAllUnauthInstitutions();
        Institution getByID(long id);
        Institution insertInstitution(Institution inst);
        string login(Institution institution);
        Institution editData(Institution inst);
        Institution editPassword(long id, string password, string newPassword);
        bool deleteInstitution(long id);
        Institution acceptInstitution(long id);
        List<Institution> getAuthInstitutionByCityId(long cityId);
        List<Institution> getUnauthInstitutionByCityId(long cityId);
        Institution editInstitutionProfilePhoto(long id, string photoPath);
    }
}
