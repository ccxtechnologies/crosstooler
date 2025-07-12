--  Copyright 2025, CCX Technologies

package Bb_Runtimes is

   Version  : constant String := "15.1.0-1";
   Checksum : constant String :=
     "26099a169ac5092aa405378bc60f059c791160d8ec2aefecb2bae807f17bff68";
   Name     : constant String := "bb-runtimes-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Bb_Runtimes;
