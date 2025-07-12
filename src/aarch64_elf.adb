--  Copyright 2025, CCX Technologies

with Ada.Environment_Variables;

with Logger;
with File_System;

with Builder;
with Binutils;
with Gcc;
with Gmp;
with Mpfr;
with Mpc;
with Isl;
with Zlib;
with Zstd;
with Newlib;
with Bb_Runtimes;

package body Aarch64_Elf is

   package Log is new Logger ("aarch64-elf");

   Architecture      : constant String := "aarch64-elf";
   Gnat_Package_Name : constant String :=
     "gnat-aarch64-elf-linux64-x86_64-" & Gcc.Version & "-2";

   procedure Download is
   begin
      Binutils.Download;
      Gcc.Download;
      Gmp.Download;
      Mpfr.Download;
      Mpc.Download;
      Isl.Download;
      Zlib.Download;
      Zstd.Download;
      Newlib.Download;
      Bb_Runtimes.Download;
   end Download;

   procedure Extract is
   begin
      Binutils.Extract (Architecture);
      Gcc.Extract (Architecture);
      Gmp.Extract (Architecture);
      Mpfr.Extract (Architecture);
      Mpc.Extract (Architecture);
      Isl.Extract (Architecture);
      Zlib.Extract (Architecture);
      Zstd.Extract (Architecture);
      Newlib.Extract (Architecture);
      Bb_Runtimes.Extract (Architecture);
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

      Zlib.Build (Gnat_Package_Name, Architecture);
      Zstd.Build (Gnat_Package_Name, Architecture);

      Gcc.Build_Bootstrap (Gnat_Package_Name, Architecture);

      Newlib.Build (Gnat_Package_Name, Architecture);
      Gcc.Build (Gnat_Package_Name, Architecture);
      Bb_Runtimes.Build (Gnat_Package_Name, Architecture);

      Ada.Environment_Variables.Set ("PATH", Path);

      Builder.Create_Gnat_Package (Gnat_Package_Name);
      Log.Heading ("Created toolchain: " & Gnat_Package_Name);

   end Build;

end Aarch64_Elf;
