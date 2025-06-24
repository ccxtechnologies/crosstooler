--  Copyright 2025, CCX Technologies

pragma Ada_2022;

with GNAT.OS_Lib;
with GNAT.Expect;

with Logger;

package body Shell_Commands is
   package Log is new Logger ("shell");

   procedure Execute (Command : String) is
      Exit_Code : Integer;

      Arguments  : GNAT.OS_Lib.Argument_List_Access   :=
        GNAT.OS_Lib.Argument_String_To_List (Command);
      Executable : constant GNAT.OS_Lib.String_Access :=
        GNAT.OS_Lib.Locate_Exec_On_Path (Arguments (Arguments'First).all);

      use type GNAT.OS_Lib.String_Access;
   begin
      if Executable = null then
         raise Failure
           with "Command not found:" & Arguments (Arguments'First).all'Image;
      end if;

      Log.Debug ("Executing: " & Command'Image);

      Exit_Code :=
        GNAT.OS_Lib.Spawn
          (Program_Name => Executable.all,
           Args         => Arguments (Arguments'First + 1 .. Arguments'Last));
      GNAT.OS_Lib.Free (Arguments);

      if Exit_Code /= 0 then
         raise Failure with "Command failed returning:" & Exit_Code'Image;
      end if;
   end Execute;

   function Execute (Command : String) return String is
      Input     : constant String := "";
      Exit_Code : aliased Integer;

      Arguments  : GNAT.OS_Lib.Argument_List_Access   :=
        GNAT.OS_Lib.Argument_String_To_List (Command);
      Executable : constant GNAT.OS_Lib.String_Access :=
        GNAT.OS_Lib.Locate_Exec_On_Path (Arguments (Arguments'First).all);

      use type GNAT.OS_Lib.String_Access;
   begin
      if Executable = null then
         raise Failure
           with "Command not found:" & Arguments (Arguments'First).all'Image;
      end if;

      Log.Debug ("Executing: " & Command'Image);

      declare
         Response : constant String :=
           GNAT.Expect.Get_Command_Output
             (Command   => Executable.all,
              Arguments => Arguments (Arguments'First + 1 .. Arguments'Last),
              Input => Input, Status => Exit_Code'Access, Err_To_Out => False);
      begin

         GNAT.OS_Lib.Free (Arguments);

         if Exit_Code /= 0 then
            raise Failure with "Command failed returning:" & Exit_Code'Image;
         end if;

         return Response;
      end;
   end Execute;

end Shell_Commands;
