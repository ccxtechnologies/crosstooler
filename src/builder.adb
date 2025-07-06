--  Copyright 2025, CCX Technologies

with File_System;

package body Builder is

   Crosstooler_Directory : constant String := "ct-build";
   Stamp_Directory : constant String := Crosstooler_Directory & "/stamps";
   Download_Directory    : constant String :=
     Crosstooler_Directory & "/downloads";

   procedure Make_Directories is
   begin
      File_System.Make_Directory (Stamp_Directory);
      File_System.Make_Directory (Download_Directory);
   end Make_Directories;

   procedure Download (Filename : String; Url : String; Checksum : String) is
   begin
      if not File_System.Is_Stamped ("download", Filename, Stamp_Directory)
      then
         File_System.Download (Filename, Url, Download_Directory, Checksum);
         File_System.Stamp ("download", Filename, Stamp_Directory);
      end if;
   end Download;

end Builder;
