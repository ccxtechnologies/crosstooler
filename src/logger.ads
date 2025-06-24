--  Copyright 2025, CCX Technologies

generic
   Label : String;
package Logger is

   procedure Heading (Message : String);
   procedure Debug (Message : String);
   procedure Info (Message : String);
   procedure Warning (Message : String);
   procedure Error (Message : String);

end Logger;
