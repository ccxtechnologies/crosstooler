--  Copyright 2025, CCX Technologies

with Ada.Directories;

with Builder;
with Logger;
with Shell_Commands;

package body Bb_Runtimes is
   package Log is new Logger ("bb-runtimes");

   Filename : constant String := "v" & Version & ".tar.gz";
   Url      : constant String :=
     "https://github.com/alire-project/bb-runtimes/archive";

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
      Base_Directory    : constant String := Ada.Directories.Current_Directory;
      Source_Directory  : constant String :=
        Builder.Source_Directory (Architecture) & "/" & Name;
      Sysroot_Directory : constant String :=
        Builder.Sysroot_Directory (Gnat_Package_Name, Architecture);
   begin
      Log.Info ("Building Version " & Version & " ...");

      Ada.Directories.Set_Directory (Source_Directory);

      Shell_Commands.Execute
        (Source_Directory & "/build_rts.py --force --rts-src-descriptor=" &
         Source_Directory & "/gnat_rts_sources/lib/gnat/rts-sources.json" &
         " --output=" & Sysroot_Directory & "/lib/gnat" & " --build" &
         " --build-flag=-cargs:C-I" & Sysroot_Directory & "/include" &
         " rpi3 rpi3mc zynqmp");

      Ada.Directories.Set_Directory (Base_Directory);

   end Build;

end Bb_Runtimes;
