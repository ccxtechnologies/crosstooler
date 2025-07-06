--  Copyright 2025, CCX Technologies

package Builder is

   procedure Make_Directories (Architecture : String);

   procedure Download (Filename : String; Url : String; Checksum : String);
   procedure Extract (Filename : String; Architecture : String);

   procedure Configure
     (Name : String; Architecture : String; Options : String);
   procedure Build
     (Name           : String; Architecture : String; Target : String := "";
      Install_Target : String := "install"; Options : String := "";
      Step           : String := "1");

   procedure Make_In_Place
     (Name    : String; Architecture : String; Target : String := "";
      Options : String := "");
   procedure Install_In_Place
     (Name    : String; Architecture : String; Target : String := "install";
      Options : String := "");
   procedure Build_In_Place
     (Name    : String; Architecture : String; Target : String := "";
      Options : String := "");

end Builder;
