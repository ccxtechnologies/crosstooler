--  Copyright 2025, CCX Technologies

package Zstd is

   Version  : constant String := "1.5.7";
   Checksum : constant String :=
     "eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3";
   Name     : constant String := "zstd-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Zstd;
