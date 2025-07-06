--  Copyright 2025, CCX Technologies

with Builder;
with Logger;

package body Isl is
   package Log is new Logger ("isl");

   Filename : constant String := Name & ".tar.xz";
   Url      : constant String := "https://libisl.sourceforge.io";

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

end Isl;
