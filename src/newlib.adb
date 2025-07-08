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

end Newlib;
