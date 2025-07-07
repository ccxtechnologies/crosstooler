--  Copyright 2025, CCX Technologies

with Ada.Directories;

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

   function Source_Directory (Architecture : String) return String is
   begin
      return Crosstooler_Directory & "/source/" & Architecture;
   end Source_Directory;

   function Build_Directory (Architecture : String) return String is
   begin
      return Crosstooler_Directory & "/build/" & Architecture;
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

   procedure Configure (Name : String; Architecture : String; Options : String)
   is
      Stamp : constant String := "configured";
   begin
      if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
         Tools.Configure
           (Name, Source_Directory (Architecture),
            Build_Directory (Architecture), Options);
         File_System.Stamp (Stamp, Name, Stamp_Directory);
      end if;
   end Configure;

   procedure Build
     (Name           : String; Architecture : String; Target : String := "";
      Install_Target : String := "install"; Options : String := "";
      Step           : String := "1")
   is
      Stamp : constant String := "build." & Step;
   begin
      if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
         Tools.Build
           (Name, Build_Directory (Architecture), Target, Install_Target,
            Options);
         File_System.Stamp (Stamp, Name, Stamp_Directory);
      end if;
   end Build;

   procedure Make_In_Place
     (Name    : String; Architecture : String; Target : String := "";
      Options : String := "")
   is
      Stamp : constant String := "configured";
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
      Stamp : constant String := "install";
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
      Stamp : constant String := "build";
   begin
      if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
         Tools.Build
           (Name, Source_Directory (Architecture), Target, Options => Options);
         File_System.Stamp (Stamp, Name, Stamp_Directory);
      end if;
   end Build_In_Place;

   procedure Create_Gnat_Package (Gnat_Package_Name : String) is
   begin
      Log.Info ("Creating Gnat Package: " & Gnat_Package_Name);
      Shell_Commands.Execute
        ("tar --directory " & Toolchain_Directory (Gnat_Package_Name) &
         "/.. " & "-czf " & Gnat_Package_Name & ".tar.gz " &
         Gnat_Package_Name);
   end Create_Gnat_Package;

end Builder;
