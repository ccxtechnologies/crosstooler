--  Copyright 2025, CCX Technologies

package Builder is

   function Source_Directory (Architecture : String) return String;
   function Toolchain_Directory (Gnat_Package_Name : String) return String;
   function Sysroot_Directory
     (Gnat_Package_Name : String; Architecture : String) return String;
   function Build_Directory
     (Architecture : String; Variant : String := "") return String;

   procedure Make_Directories (Architecture : String);

   procedure Download (Filename : String; Url : String; Checksum : String);
   procedure Extract (Filename : String; Architecture : String);

   procedure Configure
     (Name    : String; Architecture : String; Options : String;
      Variant : String := "");
   procedure Build
     (Name           : String; Architecture : String; Target : String := "";
      Install_Target : String := "install"; Options : String := "";
      Step           : String := "1"; Variant : String := "";
      Subdirectory   : String := "");

   procedure Make_In_Place
     (Name    : String; Architecture : String; Target : String := "";
      Options : String := "");
   procedure Install_In_Place
     (Name    : String; Architecture : String; Target : String := "install";
      Options : String := "");
   procedure Build_In_Place
     (Name    : String; Architecture : String; Target : String := "";
      Options : String := "");

   function Gnat_Package_File (Gnat_Package_Name : String) return String;
   procedure Create_Gnat_Package (Gnat_Package_Name : String);

end Builder;
