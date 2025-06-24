--  Copyright 2025, CCX Technologies

with Ada.Text_IO;
with Ada.Characters.Latin_1;

package body Logger is

   Esc           : constant Character := Ada.Characters.Latin_1.ESC;
   Colour_Red    : constant String    := Esc & "[38;5;160m";
   Colour_Orange : constant String    := Esc & "[38;5;202m";
   Colour_Blue   : constant String    := Esc & "[38;5;117m";
   Colour_Gray   : constant String    := Esc & "[38;5;252m";
   Colour_Purple : constant String    := Esc & "[38;5;5m";
   Colour_None   : constant String    := Esc & "[0m";

   procedure Output (Message : String) is
   begin
      Ada.Text_IO.Put_Line
        (Ada.Text_IO.Standard_Error, Label & Message & Colour_None);
   end Output;

   procedure Heading (Message : String) is
      Prompt : constant String := Colour_Purple & " == ";
   begin
      Output (Prompt & Message);
   end Heading;

   procedure Debug (Message : String) is
      Prompt : constant String := Colour_Gray & " ~> ";
   begin
      Output (Prompt & Message);
   end Debug;

   procedure Info (Message : String) is
      Prompt : constant String := Colour_Blue & " -> ";
   begin
      Output (Prompt & Message);
   end Info;

   procedure Warning (Message : String) is
      Prompt : constant String := Colour_Orange & " => ";
   begin
      Output (Prompt & Message);
   end Warning;

   procedure Error (Message : String) is
      Prompt : constant String := Colour_Red & " |> ";
   begin
      Output (Prompt & Message);
   end Error;

end Logger;
