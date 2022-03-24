using Backend.BL.Interfaces;
using Backend.Models;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class BlockedUsersUI :IBlockedUsersUI
    {
        private readonly IBlockedUsersBL _iBlockedUsersBL;

        public BlockedUsersUI(IBlockedUsersBL iBlockedUsersBL)
        {
            _iBlockedUsersBL = iBlockedUsersBL;
        }

        public List<BlockedUsers> getAllBlockedUsers()
        {
            return _iBlockedUsersBL.getAllBlockedUsers();
        }

        public BlockedUsers insertBlock(BlockedUsers block)
        {
            return _iBlockedUsersBL.insertBlock(block);
        }
    }
}
