--  Copyright 2025, CCX Technologies

package Isl is

   Version  : constant String := "0.26";
   Checksum : constant String :=
     "a0b5cb06d24f9fa9e77b55fabbe9a3c94a336190345c2555f9915bb38e976504";
   Name     : constant String := "isl-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

end Isl;
