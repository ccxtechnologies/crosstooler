--  Copyright 2025, CCX Technologies

with Ada.Directories;

with GNAT.Source_Info;
with GNAT.OS_Lib;

with Crosstooler_Config;
with Logger;

with Shell_Commands;
with Builder;

with Binutils;
with Kernel_Headers;
with Gcc;
with Glibc;
with Gmp;
with Mpfr;
with Mpc;
with Isl;
with Zlib;
with Zstd;

procedure Crosstooler is
   package Log is new Logger (Crosstooler_Config.Crate_Name);

   Architecture : constant String := "aarch64-linux-gnu";

   Gnat_Package_Name : constant String :=
     "gnat-aarch64-linux64-x86_64-" & Gcc.Version & "-1";

   Crosstooler_Directory : constant String := "ct-build";

   Base_Directory      : constant String := Ada.Directories.Current_Directory;
   Toolchain_Directory : constant String :=
     Base_Directory & "/" & Crosstooler_Directory & "/toolchain/" &
     Gnat_Package_Name;

   procedure Download_All is

   begin

      Binutils.Download;
      Kernel_Headers.Download;
      Gcc.Download;
      Glibc.Download;
      Gmp.Download;
      Mpfr.Download;
      Mpc.Download;
      Isl.Download;
      Zlib.Download;
      Zstd.Download;

   end Download_All;

   procedure Extract_All is

   begin

      Binutils.Extract (Architecture);
      Kernel_Headers.Extract (Architecture);
      Gcc.Extract (Architecture);
      Glibc.Extract (Architecture);
      Gmp.Extract (Architecture);
      Mpfr.Extract (Architecture);
      Mpc.Extract (Architecture);
      Isl.Extract (Architecture);
      Zlib.Extract (Architecture);
      Zstd.Extract (Architecture);

   end Extract_All;

   procedure Build_All is

   begin

      Binutils.Build (Gnat_Package_Name, Architecture);
      Kernel_Headers.Install (Gnat_Package_Name, Architecture);

      Zlib.Build (Gnat_Package_Name, Architecture);
      Zstd.Build (Gnat_Package_Name, Architecture);

      Gcc.Build_Bootstrap (Gnat_Package_Name, Architecture);
      Glibc.Build_Bootstrap (Gnat_Package_Name, Architecture);
      Gcc.Build_Libgcc (Gnat_Package_Name, Architecture);

      Glibc.Build (Gnat_Package_Name, Architecture);
      Gcc.Build (Gnat_Package_Name, Architecture);

   end Build_All;

   procedure Create_Gnat_Package is
   begin
      Log.Info ("Creating Gnat Package: " & Gnat_Package_Name);
      Shell_Commands.Execute
        ("tar --directory " & Toolchain_Directory & "/.. " & "-czf " &
         Gnat_Package_Name & ".tar.gz " & Gnat_Package_Name);
   end Create_Gnat_Package;

begin

   Log.Heading ("Version: " & Crosstooler_Config.Crate_Version);
   Log.Heading
     ("Compiled: " & GNAT.Source_Info.Compilation_ISO_Date & "T" &
      GNAT.Source_Info.Compilation_Time);

   Builder.Make_Directories (Architecture);

   Download_All;
   Extract_All;
   Build_All;

   Create_Gnat_Package;

   Log.Heading ("Complete");
   GNAT.OS_Lib.OS_Exit (0);

end Crosstooler;
