--  Copyright 2025, CCX Technologies

with Ada.Environment_Variables;

with Logger;
with File_System;

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

package body Aarch64_Linux is

   package Log is new Logger ("aarch64-linux");

   Architecture      : constant String := "aarch64-linux-gnu";
   Gnat_Package_Name : constant String :=
     "gnat-aarch64-linux64-x86_64-" & Gcc.Version & "-1";

   procedure Download is
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
   end Download;

   procedure Extract is
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
   end Extract;

   procedure Build is
      Path : constant String := Ada.Environment_Variables.Value ("PATH");
   begin

      if File_System.Exists (Builder.Gnat_Package_File (Gnat_Package_Name))
      then
         Log.Warning ("GNAT package already exists, skipping");
         return;
      else
         Log.Heading ("Building " & Gnat_Package_Name);
      end if;

      Builder.Make_Directories (Architecture);

      Download;
      Extract;

      Ada.Environment_Variables.Set
        ("PATH",
         Builder.Toolchain_Directory (Gnat_Package_Name) & "/bin:" & Path);

      Binutils.Build (Gnat_Package_Name, Architecture);
      Kernel_Headers.Install (Gnat_Package_Name, Architecture);

      Zlib.Build (Gnat_Package_Name, Architecture);
      Zstd.Build (Gnat_Package_Name, Architecture);

      Gcc.Build_Bootstrap (Gnat_Package_Name, Architecture);
      Glibc.Build_Bootstrap (Gnat_Package_Name, Architecture);
      Gcc.Build_Libgcc (Gnat_Package_Name, Architecture);

      Glibc.Build (Gnat_Package_Name, Architecture);
      Gcc.Build (Gnat_Package_Name, Architecture);

      Ada.Environment_Variables.Set ("PATH", Path);

      Builder.Create_Gnat_Package (Gnat_Package_Name);

      Log.Heading ("Created toolchain: " & Gnat_Package_Name);

   end Build;

end Aarch64_Linux;
