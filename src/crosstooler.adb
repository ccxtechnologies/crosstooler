--  CopyrArchitecture, ight 2025, CCX Technologies

with Ada.Directories;
with Ada.Environment_Variables;

with GNAT.Source_Info;
with GNAT.OS_Lib;

with Crosstooler_Config;
with Logger;

with File_System;
with Shell_Commands;
with Builder;

with Binutils;
with Kernel_Headers;

procedure Crosstooler is
   package Log is new Logger (Crosstooler_Config.Crate_Name);

   Architecture : constant String := "aarch64-linux-gnu";

   Gcc_Version  : constant String := "15.1.0";
   Gcc_Checksum : constant String :=
     "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea";

   Glibc_Version  : constant String := "2.41";
   Glibc_Checksum : constant String :=
     "a5a26b22f545d6b7d7b3dd828e11e428f24f4fac43c934fb071b6a7d0828e901";

   Gmp_Version  : constant String := "6.3.0";
   Gmp_Checksum : constant String :=
     "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898";

   Mpfr_Version  : constant String := "4.2.1";
   Mpfr_Checksum : constant String :=
     "277807353a6726978996945af13e52829e3abd7a9a5b7fb2793894e18f1fcbb2";

   Mpc_Version  : constant String := "1.3.1";
   Mpc_Checksum : constant String :=
     "ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8";

   Isl_Version  : constant String := "0.26";
   Isl_Checksum : constant String :=
     "a0b5cb06d24f9fa9e77b55fabbe9a3c94a336190345c2555f9915bb38e976504";

   Zlib_Version  : constant String := "1.3.1";
   Zlib_Checksum : constant String :=
     "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23";

   Zstd_Version  : constant String := "1.5.7";
   Zstd_Checksum : constant String :=
     "eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3";

   Gnat_Package_Name : constant String :=
     "gnat-aarch64-linux64-x86_64-" & Gcc_Version & "-1";

   Crosstooler_Directory : constant String := "ct-build";
   Stamp_Directory : constant String := Crosstooler_Directory & "/stamps";
   Source_Directory : constant String := Crosstooler_Directory & "/source";
   Build_Directory       : constant String := Crosstooler_Directory & "/build";

   Base_Directory      : constant String := Ada.Directories.Current_Directory;
   Toolchain_Directory : constant String :=
     Base_Directory & "/" & Crosstooler_Directory & "/toolchain/" &
     Gnat_Package_Name;
   Sysroot_Directory   : constant String :=
     Toolchain_Directory & "/" & Architecture;

   Gnu_Server : constant String := "https://mirror.csclub.uwaterloo.ca/gnu";

   Gcc_Name     : constant String := "gcc-" & Gcc_Version;
   Gcc_Filename : constant String := Gcc_Name & ".tar.xz";
   Gcc_Url      : constant String := Gnu_Server & "/gcc/gcc-" & Gcc_Version;

   Glibc_Name     : constant String := "glibc-" & Glibc_Version;
   Glibc_Filename : constant String := Glibc_Name & ".tar.xz";
   Glibc_Url      : constant String := Gnu_Server & "/glibc";

   Gmp_Name     : constant String := "gmp-" & Gmp_Version;
   Gmp_Filename : constant String := Gmp_Name & ".tar.xz";
   Gmp_Url      : constant String := Gnu_Server & "/gmp";

   Mpfr_Name     : constant String := "mpfr-" & Mpfr_Version;
   Mpfr_Filename : constant String := Mpfr_Name & ".tar.xz";
   Mpfr_Url      : constant String := Gnu_Server & "/mpfr";

   Mpc_Name     : constant String := "mpc-" & Mpc_Version;
   Mpc_Filename : constant String := Mpc_Name & ".tar.gz";
   Mpc_Url      : constant String := Gnu_Server & "/mpc";

   Isl_Name     : constant String := "isl-" & Isl_Version;
   Isl_Filename : constant String := Isl_Name & ".tar.xz";
   Isl_Url      : constant String := "https://libisl.sourceforge.io";

   Zlib_Name     : constant String := "zlib-" & Zlib_Version;
   Zlib_Filename : constant String := Zlib_Name & ".tar.gz";
   Zlib_Url      : constant String := "https://www.zlib.net";

   Zstd_Name     : constant String := "zstd-" & Zstd_Version;
   Zstd_Filename : constant String := Zstd_Name & ".tar.gz";
   Zstd_Url      : constant String :=
     "https://github.com/facebook/zstd/releases/download/v" & Zstd_Version;

   procedure Download_All is

   begin

      Binutils.Download;
      Kernel_Headers.Download;

      Builder.Download (Gcc_Filename, Gcc_Url, Gcc_Checksum);
      Builder.Download (Glibc_Filename, Glibc_Url, Glibc_Checksum);
      Builder.Download (Gmp_Filename, Gmp_Url, Gmp_Checksum);
      Builder.Download (Mpfr_Filename, Mpfr_Url, Mpfr_Checksum);
      Builder.Download (Mpc_Filename, Mpc_Url, Mpc_Checksum);
      Builder.Download (Isl_Filename, Isl_Url, Isl_Checksum);
      Builder.Download (Zlib_Filename, Zlib_Url, Zlib_Checksum);
      Builder.Download (Zstd_Filename, Zstd_Url, Zstd_Checksum);

   end Download_All;

   procedure Extract_All is

   begin

      Binutils.Extract (Architecture);
      Kernel_Headers.Extract (Architecture);

      Builder.Extract (Gcc_Filename, Architecture);
      Builder.Extract (Glibc_Filename, Architecture);
      Builder.Extract (Gmp_Filename, Architecture);
      Builder.Extract (Mpfr_Filename, Architecture);
      Builder.Extract (Mpc_Filename, Architecture);
      Builder.Extract (Isl_Filename, Architecture);
      Builder.Extract (Zlib_Filename, Architecture);
      Builder.Extract (Zstd_Filename, Architecture);

   end Extract_All;

   procedure Build_All is

      procedure Gcc_Link (Name : String; Source : String) is
         Stamp : constant String := "gcc-linked";
      begin
         --  GCC expects its prerequisites to be in its source directory
         if not File_System.Is_Stamped (Stamp, Name, Stamp_Directory) then
            File_System.Symbolic_Link
              ("../" & Source, Source_Directory & "/" & Gcc_Name & "/" & Name);
            File_System.Stamp (Stamp, Name, Stamp_Directory);
         end if;
      end Gcc_Link;

      procedure Build_Zlib is
      begin
         Log.Info ("Building Zlib...");
         Builder.Configure
           (Zlib_Name, Architecture, "--prefix=" & Sysroot_Directory);
         Builder.Build (Zlib_Name, Architecture);
      end Build_Zlib;

      procedure Build_Zstd is
      begin
         Log.Info ("Building Zstd...");

         Builder.Build_In_Place
           (Zstd_Name, Architecture, Options => "prefix=" & Sysroot_Directory);
      end Build_Zstd;

      procedure Build_Gcc_Bootstrap is
      begin
         Log.Info ("Building GCC Bootstrap...");

         Gcc_Link ("gmp", Gmp_Name);
         Gcc_Link ("mpfr", Mpfr_Name);
         Gcc_Link ("mpc", Mpc_Name);
         Gcc_Link ("isl", Isl_Name);

         Builder.Configure
           (Gcc_Name, Architecture,
            "--prefix=/" & " --with-sysroot=" & Sysroot_Directory &
            " --with-native-system-header-dir=/include" & " --target=" &
            Architecture & " --disable-multilib " &
            "--disable-libquadmath --disable-libquadmath-support" &
            " --enable-default-pie" & " --enable-libada" &
            " --enable-libstdcxx --enable-libstdcxx-threads" &
            " --disable-libsanitizer --disable-nls" &
            " --enable-languages=c,c++,ada");
         Builder.Build
           (Gcc_Name, Architecture, "all-gcc", "install-gcc",
            Options => "DESTDIR=" & Toolchain_Directory, Step => "1");
      end Build_Gcc_Bootstrap;

      procedure Build_Glibc_Bootstrap is
      begin
         Log.Info ("Building Glibc Bootstrap...");

         Ada.Environment_Variables.Set
           ("CC", Toolchain_Directory & "/bin/" & Architecture & "-gcc");
         Ada.Environment_Variables.Set
           ("CXX", Toolchain_Directory & "/bin/" & Architecture & "-gcc");
         Ada.Environment_Variables.Set
           ("LD", Toolchain_Directory & "/bin/" & Architecture & "-ld");
         Ada.Environment_Variables.Set
           ("AR", Toolchain_Directory & "/bin/" & Architecture & "-ar");
         Ada.Environment_Variables.Set
           ("RANLIB",
            Toolchain_Directory & "/bin/" & Architecture & "-ranlib");

         Builder.Configure
           (Glibc_Name, Architecture,
            "--prefix=/" & " --host=" & Architecture & " --target=" &
            Architecture & " --with-headers=" & Sysroot_Directory &
            "/include" &
            " --disable-lipquadmath --disable-libquadmath-support" &
            " --disable-libitm --disable-multilib" &
            " libc_cv_forced_unwind=yes");

         Ada.Environment_Variables.Clear ("CC");
         Ada.Environment_Variables.Clear ("LD");
         Ada.Environment_Variables.Clear ("AR");
         Ada.Environment_Variables.Clear ("RANLIB");

         Builder.Build
           (Glibc_Name, Architecture, "csu/subdir_lib", "install-headers",
            "install-bootstrap-headers=yes install_root=" & Sysroot_Directory,
            Step => "1");

         declare
            Destination : constant String := Sysroot_Directory & "/lib";
            Source      : constant String :=
              Build_Directory & "/" & Glibc_Name & "/csu";
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

      end Build_Glibc_Bootstrap;

      procedure Build_Libgcc is
      begin
         Log.Info ("Building Libgcc...");
         Builder.Build
           (Gcc_Name, Architecture, "all-target-libgcc",
            "install-target-libgcc",
            Options => "DESTDIR=" & Toolchain_Directory, Step => "2");
      end Build_Libgcc;

      procedure Build_Glibc is
      begin
         Log.Info ("Building Glibc...");
         Builder.Build
           (Glibc_Name, Architecture,
            Options => "install_root=" & Sysroot_Directory, Step => "2");

         --  update the libc.so linker definition so that the installed library
         --  is relocatable
         Shell_Commands.Execute
           ("sed -i s;//lib/;;g " & Sysroot_Directory & "/lib/libc.so");
      end Build_Glibc;

      procedure Build_Gcc is
      begin
         Log.Info ("Building Gcc...");
         Builder.Build
           (Gcc_Name, Architecture, Install_Target => "install-strip",
            Options => "DESTDIR=" & Toolchain_Directory, Step => "3");
      end Build_Gcc;

   begin

      Binutils.Build (Gnat_Package_Name, Architecture);
      Kernel_Headers.Install (Gnat_Package_Name, Architecture);

      Build_Zlib;
      Build_Zstd;

      Build_Gcc_Bootstrap;
      Build_Glibc_Bootstrap;
      Build_Libgcc;

      Build_Glibc;
      Build_Gcc;

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
