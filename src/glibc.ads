--  Copyright 2025, CCX Technologies

package Glibc is

   Version  : constant String := "2.41";
   Checksum : constant String :=
     "a5a26b22f545d6b7d7b3dd828e11e428f24f4fac43c934fb071b6a7d0828e901";
   Name     : constant String := "glibc-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build_Bootstrap
     (Gnat_Package_Name : String; Architecture : String);
   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Glibc;
