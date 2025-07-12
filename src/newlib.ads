--  Copyright 2025, CCX Technologies

package Newlib is

   Version  : constant String := "4.5.0.20241231";
   Checksum : constant String :=
     "33f12605e0054965996c25c1382b3e463b0af91799001f5bb8c0630f2ec8c852";
   Name     : constant String := "newlib-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Build (Gnat_Package_Name : String; Architecture : String);

end Newlib;
