--  Copyright 2025, CCX Technologies

package Shell_Commands is

   Failure : exception;

   procedure Execute (Command : String);
   function Execute (Command : String) return String;

end Shell_Commands;
