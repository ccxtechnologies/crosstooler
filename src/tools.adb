--  Copyright 2025, CCX Technologies

with Ada.Directories;
with System.Multiprocessors;

with Logger;
with File_System;
with Shell_Commands;

package body Tools is
   package Log is new Logger ("builder");

   procedure Configure
     (Name : String; Source : String; Destination : String; Options : String)
   is
      Base_Directory : constant String := Ada.Directories.Current_Directory;

      Build_Directory   : constant String :=
        Base_Directory & "/" & Destination & "/" & Name;
      Configure_Command : constant String :=
        Base_Directory & "/" & Source & "/" & Name & "/" & "configure";
   begin
      File_System.Make_Directory (Build_Directory);
      Ada.Directories.Set_Directory (Build_Directory);

      Log.Info ("Configuring: " & Name);
      Shell_Commands.Execute (Configure_Command & " " & Options);

      Ada.Directories.Set_Directory (Base_Directory);
   end Configure;

   procedure Build
     (Name : String; Destination : String; Build_Target : String := "";
      Install_Target : String := "install"; Options : String := "")
   is
      Base_Directory : constant String := Ada.Directories.Current_Directory;

      Build_Directory : constant String :=
        Base_Directory & "/" & Destination & "/" & Name;
   begin
      Log.Info ("Building: " & Name);

      Shell_Commands.Execute
        ("make --directory=" & Build_Directory & " --jobs" &
         System.Multiprocessors.Number_Of_CPUs'Image & " " & Options & " " &
         Build_Target);

      Shell_Commands.Execute
        ("make --directory=" & Build_Directory & " " & Options & " " &
         Install_Target);
   end Build;

   procedure Make
     (Name    : String; Destination : String; Target : String;
      Options : String := "")
   is
      Base_Directory : constant String := Ada.Directories.Current_Directory;

      Build_Directory : constant String :=
        Base_Directory & "/" & Destination & "/" & Name;
   begin
      Log.Info ("Making: " & Name);
      Shell_Commands.Execute
        ("make --directory=" & Build_Directory & " --jobs" &
         System.Multiprocessors.Number_Of_CPUs'Image & " " & Options & " " &
         Target);
   end Make;

end Tools;
