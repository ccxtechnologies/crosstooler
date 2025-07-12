--  Copyright 2025, CCX Technologies

pragma Ada_2022;

with Ada.Directories;
with Ada.Text_IO;
with Ada.Calendar;
with Ada.Calendar.Formatting;

with Logger;
with Shell_Commands;

package body File_System is
   package Log is new Logger ("file-system");

   procedure Make_Directory (Name : String) is
   begin
      Log.Debug ("Making directory: " & Name);
      Shell_Commands.Execute ("mkdir -p " & Name);
   end Make_Directory;

   procedure Remove (Filename : String) is
   begin
      Log.Debug ("Deleting: " & Filename);
      Shell_Commands.Execute ("rm " & Filename);
   end Remove;

   procedure Move (Source : String; Destination : String) is
   begin
      Log.Debug ("Moving: " & Source & " to " & Destination);
      Shell_Commands.Execute ("mv " & Source & " " & Destination);
   end Move;

   procedure Download
     (Filename : String; Source : String; Destination : String;
      Checksum : String)
   is
   begin
      Log.Info ("Downloading: " & Filename);
      Shell_Commands.Execute
        ("wget --no-verbose --show-progress" & " --no-clobber --continue" &
         " --directory-prefix=" & Destination & " " & Source & "/" & Filename);

      declare
         Downloaded_Checksum : constant String :=
           Shell_Commands.Execute
             ("sha256sum " & Destination & "/" & Filename);
      begin
         for Index in Downloaded_Checksum'Range loop
            exit when Downloaded_Checksum (Index) = ' ';

            if Downloaded_Checksum (Index) /= Checksum (Index) then
               Remove (Destination & "/" & Filename);
               raise Failure
                 with "Dowloaded file has incorrect checksum: " &
                 Downloaded_Checksum;
            end if;
         end loop;
      exception
         when Constraint_Error =>
            raise Failure
              with "Dowloaded file has incorrect checksum: " &
              Downloaded_Checksum;
      end;

   end Download;

   procedure Extract (Filename : String; Source : String; Destination : String)
   is
   begin
      Log.Info ("Extracting: " & Filename);
      Shell_Commands.Execute
        ("tar --totals --checkpoint=.500 -xf " & Source & "/" & Filename &
         " --directory " & Destination);
   end Extract;

   function Exists (Filename : String) return Boolean is
   begin
      return Ada.Directories.Exists (Filename);
   end Exists;

   function Is_Stamped
     (Mark : String; Name : String; Destination : String) return Boolean
   is
      Filename : constant String := Destination & "/" & Name & "-" & Mark;
   begin
      return Exists (Filename);
   end Is_Stamped;

   procedure Stamp (Mark : String; Name : String; Destination : String) is
      Filename     : constant String := Destination & "/" & Name & "-" & Mark;
      File         : Ada.Text_IO.File_Type;
      Current_Time : constant Ada.Calendar.Time := Ada.Calendar.Clock;
   begin
      Ada.Text_IO.Create
        (File => File, Mode => Ada.Text_IO.Out_File, Name => Filename);
      Ada.Text_IO.Put_Line
        (File => File, Item => Ada.Calendar.Formatting.Image (Current_Time));
      Ada.Text_IO.Close (File => File);
   end Stamp;

   procedure Write (Name : String; Destination : String; Text : String := "")
   is
      Filename : constant String := Destination & "/" & Name;
      File     : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Create
        (File => File, Mode => Ada.Text_IO.Out_File, Name => Filename);
      Ada.Text_IO.Put_Line (File => File, Item => Text);
      Ada.Text_IO.Close (File => File);
   end Write;

   procedure Symbolic_Link (Source : String; Destination : String) is
   begin
      Shell_Commands.Execute ("ln --symbolic " & Source & " " & Destination);
   end Symbolic_Link;

   procedure Install (Name : String; Source : String; Destination : String) is
   begin
      Shell_Commands.Execute
        ("install " & Source & "/" & Name & " " & Destination);
   end Install;
end File_System;
