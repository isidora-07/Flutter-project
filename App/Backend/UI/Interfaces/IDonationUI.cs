using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IDonationUI
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
