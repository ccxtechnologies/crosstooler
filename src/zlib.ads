--  Copyright 2025, CCX Technologies

package Zlib is

   Version  : constant String := "1.3.2";
   Checksum : constant String :=
     "bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16";
   Name     : constant String := "zlib-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Zlib;
