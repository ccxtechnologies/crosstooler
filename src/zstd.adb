--  Copyright 2025, CCX Technologies

with Builder;
with Logger;

package body Zstd is
   package Log is new Logger ("zstd");

   Filename : constant String := Name & ".tar.gz";
   Url      : constant String :=
     "https://github.com/facebook/zstd/releases/download/v" & Version;

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

      Builder.Build_In_Place
        (Name, Architecture,
         Options =>
           "prefix=" &
           Builder.Sysroot_Directory (Gnat_Package_Name, Architecture));
   end Build;

end Zstd;
