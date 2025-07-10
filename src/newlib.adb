--  Copyright 2025, CCX Technologies

with Builder;
with Logger;
with File_System;

package body Newlib is
   package Log is new Logger ("newlib");

   Filename : constant String := Name & ".tar.gz";
   Url      : constant String := "ftp://sourceware.org/pub/newlib";

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

   procedure Build (Gnat_Package_Name : String; Architecture : String) is
      Sysroot_Directory   : constant String :=
        Builder.Sysroot_Directory (Gnat_Package_Name, Architecture);
      Toolchain_Directory : constant String :=
        Builder.Toolchain_Directory (Gnat_Package_Name);
   begin
      Log.Info ("Building Version " & Version & " ...");

      Builder.Configure
        (Name, Architecture,
         "--prefix=/" & " --with-sysroot=" & Sysroot_Directory & " --target=" &
         Architecture &
         " --enable-newlib-io-long-long --enable-newlib-io-c99-formats" &
         " --enable-newlib-register-fini" &
         " --enable-newlib-retargetable-locking" &
         " --disable-newlib-supplied-syscalls" & " --disable-nls");

      Builder.Build
        (Name, Architecture, "all-target-newlib",
         Install_Target => "install-target-newlib",
         Options        => "DESTDIR=" & Toolchain_Directory, Step => "1");

      Builder.Build
        (Name, Architecture, "all-target-libgloss",
         Install_Target => "install-target-libgloss",
         Options        => "DESTDIR=" & Toolchain_Directory, Step => "2");

      --  Move the libgloss crt0.o which has undefined symbols and replace
      --  with an empty crt0.o os that the automated compiler checks when
      --  building libada don't fail
      File_System.Move
        (Sysroot_Directory & "/lib/crt0.o",
         Sysroot_Directory & "/lib/gloss-crt0.o");
      File_System.Write ("crt0.o", Sysroot_Directory & "/lib");

   end Build;

   procedure Cleanup (Gnat_Package_Name : String; Architecture : String) is
      Sysroot_Directory : constant String :=
        Builder.Sysroot_Directory (Gnat_Package_Name, Architecture);
   begin
      File_System.Remove (Sysroot_Directory & "/crt0.o");
      File_System.Move
        (Sysroot_Directory & "/lib/gloss-crt0.o",
         Sysroot_Directory & "/lib/crt0.o");
   end Cleanup;

end Newlib;
