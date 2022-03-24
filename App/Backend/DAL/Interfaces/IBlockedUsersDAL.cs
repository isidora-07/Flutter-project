using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
   public interface IBlockedUsersDAL
    {
        List<BlockedUsers> getAllBlockedUsers();
        BlockedUsers insertBlock(BlockedUsers block);

    }
}
