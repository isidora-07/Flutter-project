using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class DonationDAL : IDonationDAL
    {
        private readonly AppDbContext _context;

        public DonationDAL(AppDbContext context)
        {
            _context = context;
        }

        public Donation addParticipate(UserDonation ue)
        {
            bool ret = false;
            var exist = _context.userDonation.Where(x => x.userId == ue.userId && x.donationId == ue.donationId).FirstOrDefault();
            var exist1 = _context.user.Where(x => x.id == ue.userId).FirstOrDefault();
            if (exist == null && exist1.points >= ue.donatedPoints)
            {
                UserDonation eve = new UserDonation();
                eve.userId = ue.userId;
                eve.donationId = ue.donationId;
                eve.donatedPoints = ue.donatedPoints;
                if (eve != null)
                {
                    _context.userDonation.Add(eve);
                    _context.SaveChangesAsync();
                    ret = true;
                }
            }
            else if(exist1.points >= ue.donatedPoints)
            {
                try
                {
                    exist.donatedPoints += ue.donatedPoints;
                    _context.Update(exist);
                    _context.SaveChanges();
                    ret = true;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }
            Donation existDon = _context.donation.Where(x => x.id == ue.donationId).FirstOrDefault();
            if (existDon != null && ret == true)
            {
                existDon.collectedMoney += ue.donatedPoints * 10;
                if (existDon.monetaryAmount >= existDon.collectedMoney)
                    this.editDonation(existDon);
               
                try
                {
                    exist1.donatedPoints += ue.donatedPoints;
                    exist1.points -= ue.donatedPoints;
                    exist1.level = exist1.donatedPoints / 100 + 1;
                    _context.Update(exist1);
                    _context.SaveChanges();
                    ret = true;
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }
            if (ret == true)
                return _context.donation.Where(x => x.id == ue.donationId).FirstOrDefault();
            else
                return null;
        }

        public bool deleteDonation(long id)
        {
            var donation = _context.donation.Where(x => x.id == id).FirstOrDefault();
            if (donation == null)
            {
                return false;
            }

            _context.donation.Remove(donation);
            _context.SaveChangesAsync();

            return true;
        }

        public Donation editDonation(Donation donation)
        {
            var exist = _context.donation.Where(x => x.id == donation.id).FirstOrDefault();
            if (exist != null)
            {
                try
                {

                    exist.description = donation.description;
                    exist.title = donation.title;
                    exist.monetaryAmount = donation.monetaryAmount;
                    exist.organizationName = donation.organizationName;
                    _context.Update(exist);
                    _context.SaveChanges();
                    return _context.donation.Where((u) => u.id == donation.id).FirstOrDefault();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine(ex.Message);
                }

            }
            return null;
        }

        public List<Donation> getAllDonations()
        {
            return _context.donation.Where(x => x.collectedMoney < x.monetaryAmount).ToList();
        }

        public Donation getByID(long id)
        {
            return _context.donation.Where(x => x.id == id).FirstOrDefault();
        }

        public List<Donation> getFinishedDonations()
        {
            return _context.donation.Where(x => x.collectedMoney == x.monetaryAmount).ToList();
        }

        public Donation getLastDonation()
        {
            var donations = _context.donation.OrderByDescending(x=> x.id).ToList();
            return donations.FirstOrDefault();
        }

        public Donation insertDonation(Donation donation)
        {
            Donation exist = new Donation();

            exist.description = donation.description;
            exist.adminId = donation.adminId;
            exist.title = donation.title;
            exist.monetaryAmount = donation.monetaryAmount;
            exist.organizationName = donation.organizationName;
            exist.description = donation.description;
            exist.collectedMoney = 0;
            if (exist != null)
            {
                _context.donation.Add(exist);
                _context.SaveChangesAsync();
                return exist;
            }
            else
            {
                return null;
            }
        }

        public List<UserDonation> usersWhoParcipate(long donationtId)
        {
            return _context.userDonation.Where(x => x.donationId == donationtId).Include(u => u.user).ToList();
        }
    }
}
