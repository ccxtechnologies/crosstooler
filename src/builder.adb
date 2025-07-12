--  Copyright 2025, CCX Technologies

with Ada.Directories;
with Ada.Characters.Latin_1;

with File_System;
with Tools;
with Logger;
with Shell_Commands;

package body Builder is
   package Log is new Logger ("builder");

   Crosstooler_Directory : constant String :=
     Ada.Directories.Current_Directory & "/ct-build";

   Stamp_Directory    : constant String := Crosstooler_Directory & "/stamps";
   Download_Directory : constant String :=
     Crosstooler_Directory & "/downloads";

   function Is_Whitespace (Source : Character) return Boolean is
   begin
      return
        Source = Ada.Characters.Latin_1.Space
        or else Source = Ada.Characters.Latin_1.HT;
   end Is_Whitespace;

   function Strip_Whitespace (Source : String) return String is
      Start_Index : Integer := Source'First;
   begin
      for I in Source'Range loop
         Start_Index := I;
         exit when not Is_Whitespace (Source (I));
      end loop;

      return Source (Start_Index .. Source'Last);
   end Strip_Whitespace;

   function Get_Host return String is
   begin
      return Strip_Whitespace (Shell_Commands.Execute ("gcc -dumpmachine"));
   end Get_Host;

   function Source_Directory (Architecture : String) return String is
   begin
      return Crosstooler_Directory & "/source/" & Architecture;
   end Source_Directory;

   function Build_Directory
     (Architecture : String; Variant : String := "") return String
   is
      Directory : constant String :=
        Crosstooler_Directory & "/build/" & Architecture;
   begin
      if Variant = "" then
         return Directory;
      else
         return Directory & "/" & Variant;
      end if;
   end Build_Directory;

   function Toolchain_Directory (Gnat_Package_Name : String) return String is
   begin
      return Crosstooler_Directory & "/toolchain/" & Gnat_Package_Name;
   end Toolchain_Directory;

   function Sysroot_Directory
     (Gnat_Package_Name : String; Architecture : String) return String
   is
   begin
      return Toolchain_Directory (Gnat_Package_Name) & '/' & Architecture;
   end Sysroot_Directory;

   procedure Make_Directories (Architecture : String) is
   begin
      File_System.Make_Directory (Stamp_Directory);
      File_System.Make_Directory (Download_Directory);
      File_System.Make_Directory (Source_Directory (Architecture));
      File_System.Make_Directory (Build_Directory (Architecture));
   end Make_Directories;

   procedure Download (Filename : String; Url : String; Checksum : String) is
      Stamp : constant String := "download";
   begin
      if not File_System.Is_Stamped (Stamp, Filename, Stamp_Directory) then
         File_System.Download (Filename, Url, Download_Directory, Checksum);
         File_System.Stamp (Stamp, Filename, Stamp_Directory);
      end if;
   end Download;

   procedure Extract (Filename : String; Architecture : String) is
      Stamp : constant String := "extract." & Architecture;
   begin
      if not File_System.Is_Stamped (Stamp, Filename, Stamp_Directory) then
         File_System.Extract
           (Filename, Download_Directory, Source_Directory (Architecture));
         File_System.Stamp (Stamp, Filename, Stamp_Directory);
      end if;
   end Extract;

   procedure Configure
     (Name    : String; Architecture : String; Options : String;
      Variant : String := "")
   is
      Stamp : constant String :=
        "configured." & (if Variant = "" then "" else Variant & ".") &
        Architecture;
   begin
      if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
         Tools.Configure
           (Name, Source_Directory (Architecture),
            Build_Directory (Architecture, Variant), Options);
         File_System.Stamp (Stamp, Name, Stamp_Directory);
      end if;
   end Configure;

   procedure Build
     (Name           : String; Architecture : String; Target : String := "";
      Install_Target : String := "install"; Options : String := "";
      Step           : String := "1"; Variant : String := "";
      Subdirectory   : String := "")
   is
      Stamp : constant String :=
        "build." & (if Variant = "" then "" else Variant & ".") &
        Architecture & "." & Step;
   begin
      if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
         Tools.Build
           (Name & Subdirectory, Build_Directory (Architecture, Variant),
            Target, Install_Target, Options);
         File_System.Stamp (Stamp, Name, Stamp_Directory);
      end if;
   end Build;

   procedure Make_In_Place
     (Name    : String; Architecture : String; Target : String := "";
      Options : String := "")
   is
      Stamp : constant String := "configured." & Architecture;
   begin
      if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
         Tools.Make (Name, Source_Directory (Architecture), Target, Options);
         File_System.Stamp (Stamp, Name, Stamp_Directory);
      end if;
   end Make_In_Place;

   procedure Install_In_Place
     (Name    : String; Architecture : String; Target : String := "install";
      Options : String := "")
   is
      Stamp : constant String := "install." & Architecture;
   begin
      if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
         Tools.Make (Name, Source_Directory (Architecture), Target, Options);
         File_System.Stamp (Stamp, Name, Stamp_Directory);
      end if;
   end Install_In_Place;

   procedure Build_In_Place
     (Name    : String; Architecture : String; Target : String := "";
      Options : String := "")
   is
      Stamp : constant String := "build." & Architecture;
   begin
      if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
         Tools.Build
           (Name, Source_Directory (Architecture), Target, Options => Options);
         File_System.Stamp (Stamp, Name, Stamp_Directory);
      end if;
   end Build_In_Place;

   function Gnat_Package_File (Gnat_Package_Name : String) return String is
   begin
      return Gnat_Package_Name & ".tar.gz";
   end Gnat_Package_File;

   procedure Create_Gnat_Package (Gnat_Package_Name : String) is
   begin
      Log.Info ("Creating Gnat Package: " & Gnat_Package_Name);
      Shell_Commands.Execute
        ("tar --directory " & Toolchain_Directory (Gnat_Package_Name) &
         "/.. " & "-czf " & Gnat_Package_File (Gnat_Package_Name) & " " &
         Gnat_Package_Name);
   end Create_Gnat_Package;

end Builder;
