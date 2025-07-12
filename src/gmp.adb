--  Copyright 2025, CCX Technologies

with Gnu;
with Builder;
with Logger;

package body Gmp is
   package Log is new Logger ("gmp");

   Filename : constant String := Name & ".tar.xz";
   Url      : constant String := Gnu.Mirror & "/gmp";

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

end Gmp;
