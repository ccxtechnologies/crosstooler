--  Copyright 2025, CCX Technologies

package Gcc is

   Version  : constant String := "15.3.0";
   Checksum : constant String :=
     "fa59c1beef8995f27c4d71c1df227587189315d3e6faff1bb4306e61b0c530eb";
   Name     : constant String := "gcc-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build_Bootstrap
     (Gnat_Package_Name : String; Architecture : String);
   procedure Build_Libgcc (Gnat_Package_Name : String; Architecture : String);
   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Gcc;
