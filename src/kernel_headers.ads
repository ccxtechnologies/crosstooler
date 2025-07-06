--  Copyright 2025, CCX Technologies

package Kernel_Headers is

   Version  : constant String := "6.1.141";
   Checksum : constant String :=
     "bc3c45faf6f5f0450666c75fa9dad9bc7c0cf7c7cba0dbd94e5cfdc58229c116";

   procedure Download;
   procedure Extract (Architecture : String);

   procedure Install (Gnat_Package_Name : String; Architecture : String);

end Kernel_Headers;
