using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class InstitutionBL : IInstitutionBL
    {
        private readonly IInstitutionDAL _iInstitutionDAL;

        public InstitutionBL(IInstitutionDAL iInstitutionDAL)
        {
            _iInstitutionDAL = iInstitutionDAL;
        }

        public Institution acceptInstitution(long id)
        {
            return _iInstitutionDAL.acceptInstitution(id);
        }

        public bool deleteInstitution(long id)
        {
            return _iInstitutionDAL.deleteInstitution(id);
        }

        public Institution editData(Institution inst)
        {
            return _iInstitutionDAL.editData(inst);
        }

        public Institution editInstitutionProfilePhoto(long id, string photoPath)
        {
            return _iInstitutionDAL.editInstitutionProfilePhoto(id, photoPath);
        }

        public Institution editPassword(long id, string password, string newPassword)
        {
            return _iInstitutionDAL.editPassword(id, password, newPassword);
        }

        public List<Institution> getAllAuthInstitutions()
        {
            return _iInstitutionDAL.getAllAuthInstitutions();
        }

        public List<Institution> getAllUnauthInstitutions()
        {
            return _iInstitutionDAL.getAllUnauthInstitutions();
        }

        public List<Institution> getAuthInstitutionByCityId(long cityId)
        {
            return _iInstitutionDAL.getAuthInstitutionByCityId(cityId);
        }

        public Institution getByID(long id)
        {
            return _iInstitutionDAL.getByID(id);
        }

        public List<Institution> getUnauthInstitutionByCityId(long cityId)
        {
            return _iInstitutionDAL.getUnauthInstitutionByCityId(cityId);
        }

        public Institution insertInstitution(Institution inst)
        {
            return _iInstitutionDAL.insertInstitution(inst);
        }

        public string login(Institution institution)
        {
            return _iInstitutionDAL.login(institution);
        }
    }
}
