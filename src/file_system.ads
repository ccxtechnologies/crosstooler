--  Copyright 2025, CCX Technologies

package File_System is

   Failure : exception;

   procedure Make_Directory (Name : String);
   procedure Download
     (Filename : String; Source : String; Destination : String;
      Checksum : String);
   procedure Extract
     (Filename : String; Source : String; Destination : String);

   function Is_Stamped
     (Mark : String; Name : String; Destination : String) return Boolean;
   procedure Stamp (Mark : String; Name : String; Destination : String);

   procedure Symbolic_Link (Source : String; Destination : String);
   procedure Write (Name : String; Destination : String; Text : String := "");

   procedure Install (Name : String; Source : String; Destination : String);

end File_System;
