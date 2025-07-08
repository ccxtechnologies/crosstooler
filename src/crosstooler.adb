--  Copyright 2025, CCX Technologies

with GNAT.Source_Info;
with GNAT.OS_Lib;

with Crosstooler_Config;
with Logger;

with Aarch64_Linux;

procedure Crosstooler is
   package Log is new Logger (Crosstooler_Config.Crate_Name);

begin

   Log.Heading ("Version: " & Crosstooler_Config.Crate_Version);
   Log.Heading
     ("Compiled: " & GNAT.Source_Info.Compilation_ISO_Date & "T" &
      GNAT.Source_Info.Compilation_Time);

   Aarch64_Linux.Build;

   Log.Heading ("Complete");
   GNAT.OS_Lib.OS_Exit (0);

end Crosstooler;
