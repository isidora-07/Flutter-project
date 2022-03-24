using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class BlockedUsersBL : IBlockedUsersBL
    {
        private readonly IBlockedUsersDAL _iBlockedUsersDAL;

        public BlockedUsersBL(IBlockedUsersDAL iBlockedUsersDAL)
        {
            _iBlockedUsersDAL = iBlockedUsersDAL;
        }

        public List<BlockedUsers> getAllBlockedUsers()
        {
            return _iBlockedUsersDAL.getAllBlockedUsers();
        }

        public BlockedUsers insertBlock(BlockedUsers block)
        {
            return _iBlockedUsersDAL.insertBlock(block);
        }
    }
}
