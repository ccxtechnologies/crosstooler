--  Copyright 2025, CCX Technologies

with Gnu;
with Builder;
with Logger;
with File_System;

with Gmp;
with Mpfr;
with Mpc;
with Isl;

package body Gcc is
   package Log is new Logger ("gcc");

   Filename : constant String := Name & ".tar.xz";
   Url      : constant String := Gnu.Mirror & "/gcc/gcc-" & Version;

   procedure Link
     (Package_Name : String; Source : String; Architecture : String)
   is
      Link_File : constant String :=
        Builder.Source_Directory (Architecture) & "/" & Name & "/" &
        Package_Name;
   begin
      if File_System.Exists (Link_File) then
         File_System.Remove (Link_File);
      end if;
      File_System.Symbolic_Link ("../" & Source, Link_File);
   end Link;

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
   begin
      Log.Info ("Building Version " & Version & " Bootstrap...");

      Link ("gmp", Gmp.Name, Architecture);
      Link ("mpfr", Mpfr.Name, Architecture);
      Link ("mpc", Mpc.Name, Architecture);
      Link ("isl", Isl.Name, Architecture);

      if Architecture = "aarch64-linux-gnu" then

         Builder.Configure
           (Name, Architecture,
            "--prefix=/" & " --with-sysroot=" &
            Builder.Sysroot_Directory (Gnat_Package_Name, Architecture) &
            " --with-native-system-header-dir=/include" & " --target=" &
            Architecture & " --disable-multilib " &
            "--disable-libquadmath --disable-libquadmath-support" &
            " --enable-default-pie" & " --enable-libada" &
            " --enable-libstdcxx --enable-libstdcxx-threads" &
            " --disable-libsanitizer --disable-nls" &
            " --enable-languages=c,c++,ada");

      elsif Architecture = "aarch64-elf" then

         Builder.Configure
           (Name, Architecture,
            "--prefix=/" & " --with-sysroot=" &
            Builder.Sysroot_Directory (Gnat_Package_Name, Architecture) &
            " --target=" & Architecture & " --disable-multilib" &
            " --disable-libquadmath --disable-libquadmath-support" &
            " --enable-default-pie" & " --enable-libada" &
            " --disable-libsanitizer --disable-nls" & " --without-headers" &
            " --with-newlib" & " --enable-languages=c,ada");

      else
         raise Constraint_Error with "Unknown Architecture: " & Architecture;
      end if;

      Builder.Build
        (Name, Architecture, "all-gcc", "install-gcc",
         Options =>
           "DESTDIR=" & Builder.Toolchain_Directory (Gnat_Package_Name),
         Step    => "1");
   end Build_Bootstrap;

   procedure Build_Libgcc (Gnat_Package_Name : String; Architecture : String)
   is
   begin
      Log.Info ("Building Version " & Version & " Libgcc...");
      Builder.Build
        (Name, Architecture, "all-target-libgcc", "install-target-libgcc",
         Options =>
           "DESTDIR=" & Builder.Toolchain_Directory (Gnat_Package_Name),
         Step    => "2");
   end Build_Libgcc;

   procedure Build (Gnat_Package_Name : String; Architecture : String) is
   begin
      Log.Info ("Building Version " & Version & " ...");

      Builder.Build
        (Name, Architecture, Install_Target => "install-strip",
         Options                            =>
           "DESTDIR=" & Builder.Toolchain_Directory (Gnat_Package_Name),
         Step                               => "3");
   end Build;
end Gcc;
