--  Copyright 2025, CCX Technologies

with Builder;
with Logger;

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
   begin
      Log.Info ("Building Version " & Version & " ...");

      Builder.Configure
        (Name, Architecture,
         "--prefix=/" & " --with-sysroot=" &
         Builder.Sysroot_Directory (Gnat_Package_Name, Architecture) &
         " --target=" & Architecture &
         " --enable-newlib-io-long-long --enable-newlib-io-c99-formats" &
         " --enable-newlib-register-fini" &
         " --enable-newlib-retargetable-locking" &
         " --disable-newlib-supplied-syscalls" & " --disable-nls");

      Builder.Build
        (Name, Architecture, "all-target-newlib",
         Install_Target => "install-target-newlib",
         Options        =>
           "DESTDIR=" & Builder.Toolchain_Directory (Gnat_Package_Name),
         Step           => "1");

      Builder.Build
        (Name, Architecture, "all-target-libgloss",
         Install_Target => "install-target-libgloss",
         Options        =>
           "DESTDIR=" & Builder.Toolchain_Directory (Gnat_Package_Name),
         Step           => "2");

   end Build;

end Newlib;
