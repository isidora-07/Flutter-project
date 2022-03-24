using Backend.Models;
using Backend.Models.ViewsModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IDonationDAL
    {
        List<Donation> getAllDonations();
        List<Donation> getFinishedDonations();
        Donation addParticipate(UserDonation ue);
        Donation getLastDonation();
        Donation getByID(long id);
        Donation insertDonation(Donation donation);
        bool deleteDonation(long id);
        Donation editDonation(Donation donation);
        List<UserDonation> usersWhoParcipate(long donationtId);
    }
}
