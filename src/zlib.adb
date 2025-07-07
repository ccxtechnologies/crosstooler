--  Copyright 2025, CCX Technologies

with Builder;
with Logger;

package body Zlib is
   package Log is new Logger ("zlib");

   Filename : constant String := Name & ".tar.gz";
   Url      : constant String := "https://www.zlib.net";

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
         "--prefix=" &
         Builder.Sysroot_Directory (Gnat_Package_Name, Architecture));
      Builder.Build (Name, Architecture);
   end Build;

end Zlib;
