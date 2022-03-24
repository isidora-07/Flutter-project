using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class InstitutionUI : IInstitutionUI
    {

        private readonly IInstitutionBL _iInstitutionBL;

        public InstitutionUI(IInstitutionBL iInstitutionBL)
        {
            _iInstitutionBL = iInstitutionBL;
        }

        public Institution acceptInstitution(long id)
        {
            return _iInstitutionBL.acceptInstitution(id);
        }

        public bool deleteInstitution(long id)
        {
            return _iInstitutionBL.deleteInstitution(id);
        }

        public Institution editData(Institution inst)
        {
            return _iInstitutionBL.editData(inst);
        }

        public Institution editInstitutionProfilePhoto(long id, string photoPath)
        {
            return _iInstitutionBL.editInstitutionProfilePhoto(id, photoPath);
        }

        public Institution editPassword(long id, string password, string newPassword)
        {
            return _iInstitutionBL.editPassword(id, password, newPassword);
        }

        public List<Institution> getAllAuthInstitutions()
        {
            return _iInstitutionBL.getAllAuthInstitutions();
        }

        public List<Institution> getAllUnauthInstitutions()
        {
            return _iInstitutionBL.getAllUnauthInstitutions();
        }

        public List<Institution> getAuthInstitutionByCityId(long cityId)
        {
            return _iInstitutionBL.getAuthInstitutionByCityId(cityId);
        }

        public Institution getByID(long id)
        {
            return _iInstitutionBL.getByID(id);
        }

        public List<Institution> getUnauthInstitutionByCityId(long cityId)
        {
            return _iInstitutionBL.getUnauthInstitutionByCityId(cityId);
        }

        public Institution insertInstitution(Institution inst)
        {
            return _iInstitutionBL.insertInstitution(inst);
        }

        public string login(Institution institution)
        {
            return _iInstitutionBL.login(institution);
        }
    }
}
