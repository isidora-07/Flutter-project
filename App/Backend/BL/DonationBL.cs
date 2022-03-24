using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class DonationBL :IDonationBL
    {
        private readonly IDonationDAL _iDonationDAL;

        public DonationBL(IDonationDAL iDonationDAL)
        {
            _iDonationDAL = iDonationDAL;
        }

        public Donation addParticipate(UserDonation ue)
        {
            return _iDonationDAL.addParticipate(ue);
        }

        public bool deleteDonation(long id)
        {
            return _iDonationDAL.deleteDonation(id);
        }

        public Donation editDonation(Donation donation)
        {
            return _iDonationDAL.editDonation(donation);
        }

        public List<Donation> getAllDonations()
        {
            return _iDonationDAL.getAllDonations();
        }

        public Donation getByID(long id)
        {
            return _iDonationDAL.getByID(id);
        }

        public List<Donation> getFinishedDonations()
        {
            return _iDonationDAL.getFinishedDonations();
        }

        public Donation getLastDonation()
        {
            return _iDonationDAL.getLastDonation();
        }

        public Donation insertDonation(Donation donation)
        {
            return _iDonationDAL.insertDonation(donation);
        }

        public List<UserDonation> usersWhoParcipate(long donationtId)
        {
            return _iDonationDAL.usersWhoParcipate(donationtId);
        }
    }
}
