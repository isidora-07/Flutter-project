using Backend.DAL.Interfaces;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class BlockedUsersDAL : IBlockedUsersDAL
    {
        private readonly AppDbContext _context;

        public BlockedUsersDAL(AppDbContext context)
        {
            _context = context;
        }

        public List<BlockedUsers> getAllBlockedUsers()
        {
            return _context.blockedUsers.Include(x => x.blockedUser).ToList();
        }

        public BlockedUsers insertBlock(BlockedUsers block)
        {
            BlockedUsers block1 = new BlockedUsers();

            block1.userId = block.userId;
            block1.blockedUntil = DateTime.Now.AddDays(3);
            
            if (block != null)
            {
                _context.blockedUsers.Add(block1);
                _context.SaveChangesAsync();
                return block1;
            }
            else
            {
                return null;
            }
        }


    }
}
