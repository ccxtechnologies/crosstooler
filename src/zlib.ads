--  Copyright 2025, CCX Technologies

package Zlib is

   Version  : constant String := "1.3.1";
   Checksum : constant String :=
     "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23";
   Name     : constant String := "zlib-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Zlib;
