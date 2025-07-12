--  Copyright 2025, CCX Technologies

with Ada.Environment_Variables;

with Gnu;
with Builder;
with Logger;
with Shell_Commands;
with File_System;

package body Glibc is
   package Log is new Logger ("glibc");

   Filename : constant String := Name & ".tar.xz";
   Url      : constant String := Gnu.Mirror & "/glibc";

   procedure Download is
   begin
      Log.Info ("Downloading...");
      Builder.Download (Filename, Url, Checksum);
   end Download;

   procedure Extract (Architecture : String) is
   begin
      Log.Info ("Extracting...");
      Builder.Extract (Filename, Architecture);
   end Extract;

   procedure Build_Bootstrap
     (Gnat_Package_Name : String; Architecture : String)
   is
      Toolchain_Directory : constant String :=
        Builder.Toolchain_Directory (Gnat_Package_Name);
      Sysroot_Directory   : constant String :=
        Builder.Sysroot_Directory (Gnat_Package_Name, Architecture);
   begin
      Log.Info ("Building Version " & Version & " Bootstrap...");

      Ada.Environment_Variables.Set
        ("CC", Toolchain_Directory & "/bin/" & Architecture & "-gcc");
      Ada.Environment_Variables.Set
        ("CXX", Toolchain_Directory & "/bin/" & Architecture & "-gcc");
      Ada.Environment_Variables.Set
        ("LD", Toolchain_Directory & "/bin/" & Architecture & "-ld");
      Ada.Environment_Variables.Set
        ("AR", Toolchain_Directory & "/bin/" & Architecture & "-ar");
      Ada.Environment_Variables.Set
        ("RANLIB", Toolchain_Directory & "/bin/" & Architecture & "-ranlib");

      Builder.Configure
        (Name, Architecture,
         "--prefix=/" & " --host=" & Architecture & " --target=" &
         Architecture & " --with-headers=" & Sysroot_Directory & "/include" &
         " --disable-lipquadmath --disable-libquadmath-support" &
         " --disable-libitm --disable-multilib" &
         " libc_cv_forced_unwind=yes");

      Ada.Environment_Variables.Clear ("CC");
      Ada.Environment_Variables.Clear ("LD");
      Ada.Environment_Variables.Clear ("AR");
      Ada.Environment_Variables.Clear ("RANLIB");

      Builder.Build
        (Name, Architecture, "csu/subdir_lib", "install-headers",
         "install-bootstrap-headers=yes install_root=" & Sysroot_Directory,
         Step => "1");

      declare
         Destination : constant String := Sysroot_Directory & "/lib";
         Source      : constant String :=
           Builder.Build_Directory (Architecture) & "/" & Name & "/csu";
      begin
         File_System.Make_Directory (Destination);
         File_System.Install ("crt1.o", Source, Destination);
         File_System.Install ("crti.o", Source, Destination);
         File_System.Install ("crtn.o", Source, Destination);

         Shell_Commands.Execute
           (Toolchain_Directory & "/bin/" & Architecture & "-gcc " &
            "-nostdlib -nostartfiles -shared -x c /dev/null -o " &
            Destination & "/libc.so");
      end;

      File_System.Write ("stubs.h", Sysroot_Directory & "/include/gnu");

   end Build_Bootstrap;

   procedure Build (Gnat_Package_Name : String; Architecture : String) is
      Sysroot_Directory : constant String :=
        Builder.Sysroot_Directory (Gnat_Package_Name, Architecture);
   begin
      Log.Info ("Building Version " & Version & " ...");
      Builder.Build
        (Name, Architecture, Options => "install_root=" & Sysroot_Directory,
         Step                        => "2");

      --  update the libc.so linker definition so that the installed library
      --  is relocatable
      Shell_Commands.Execute
        ("sed -i s;//lib/;;g " & Sysroot_Directory & "/lib/libc.so");
   end Build;

end Glibc;
