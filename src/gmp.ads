--  Copyright 2025, CCX Technologies

package Gmp is

   Version  : constant String := "6.3.0";
   Checksum : constant String :=
     "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898";
   Name     : constant String := "gmp-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

end Gmp;
