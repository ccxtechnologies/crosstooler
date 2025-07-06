--  Copyright 2025, CCX Technologies

package Gcc is

   Version  : constant String := "15.1.0";
   Checksum : constant String :=
     "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea";
   Name     : constant String := "gcc-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build_Bootstrap
     (Gnat_Package_Name : String; Architecture : String);
   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Gcc;
