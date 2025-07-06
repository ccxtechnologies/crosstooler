--  Copyright 2025, CCX Technologies

package Tools is

   procedure Configure
     (Name : String; Source : String; Destination : String; Options : String);

   procedure Build
     (Name : String; Destination : String; Build_Target : String := "";
      Install_Target : String := "install"; Options : String := "");

   procedure Make
     (Name    : String; Destination : String; Target : String;
      Options : String := "");

end Tools;
