--  Copyright 2025, CCX Technologies

package Mpc is

   Version  : constant String := "1.3.1";
   Checksum : constant String :=
     "ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8";
   Name     : constant String := "mpc-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

end Mpc;
