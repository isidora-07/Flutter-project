using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class DonationUI :IDonationUI
    {
        private readonly IDonationBL _iDonationBL;

        public DonationUI(IDonationBL iDonationBL)
        {
            _iDonationBL = iDonationBL;
        }

        public Donation addParticipate(UserDonation ue)
        {
            return _iDonationBL.addParticipate(ue);
        }

        public bool deleteDonation(long id)
        {
            return _iDonationBL.deleteDonation(id);
        }

        public Donation editDonation(Donation donation)
        {
            return _iDonationBL.editDonation(donation);
        }

        public List<Donation> getAllDonations()
        {
            return _iDonationBL.getAllDonations();
        }

        public Donation getByID(long id)
        {
            return _iDonationBL.getByID(id);
        }

        public List<Donation> getFinishedDonations()
        {
            return _iDonationBL.getFinishedDonations();
        }

        public Donation getLastDonation()
        {
            return _iDonationBL.getLastDonation();
        }

        public Donation insertDonation(Donation donation)
        {
            return _iDonationBL.insertDonation(donation);
        }

        public List<UserDonation> usersWhoParcipate(long donationtId)
        {
            return _iDonationBL.usersWhoParcipate(donationtId);
        }
    }
}
