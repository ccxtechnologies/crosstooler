--  Copyright 2025, CCX Technologies

with Gnu;
with Builder;
with Logger;

package body Mpc is
   package Log is new Logger ("mpc");

   Filename : constant String := Name & ".tar.gz";
   Url      : constant String := Gnu.Mirror & "/mpc";

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

end Mpc;
