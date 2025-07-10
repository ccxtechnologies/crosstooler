--  Copyright 2025, CCX Technologies

package File_System is

   Failure : exception;

   function Exists (Filename : String) return Boolean;

   procedure Make_Directory (Name : String);
   procedure Remove (Filename : String);
   procedure Move (Source : String; Destination : String);
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
