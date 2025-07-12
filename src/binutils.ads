--  Copyright 2025, CCX Technologies

package Binutils is

   Version  : constant String := "2.44";
   Checksum : constant String :=
     "ce2017e059d63e67ddb9240e9d4ec49c2893605035cd60e92ad53177f4377237";
   Name     : constant String := "binutils-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Binutils;
