--  Copyright 2025, CCX Technologies

with Gnu;
with Builder;
with Logger;

package body Binutils is
   package Log is new Logger ("binutils");

   Name     : constant String := "binutils-" & Version;
   Filename : constant String := Name & ".tar.xz";
   Url      : constant String := Gnu.Mirror & "/binutils";

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
         " --disable-multilib --disable-libquadmath" &
         " --disable-libquadmath-support");
      Builder.Build
        (Name, Architecture,
         Options =>
           "DESTDIR=" & Builder.Toolchain_Directory (Gnat_Package_Name));
   end Build;

end Binutils;
