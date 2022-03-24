using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IInstitutionBL
    {
        List<Institution> getAllAuthInstitutions();
        Institution getByID(long id);
        Institution insertInstitution(Institution inst);
        List<Institution> getAllUnauthInstitutions();
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
