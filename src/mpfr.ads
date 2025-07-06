--  Copyright 2025, CCX Technologies

package Mpfr is

   Version  : constant String := "4.2.1";
   Checksum : constant String :=
     "277807353a6726978996945af13e52829e3abd7a9a5b7fb2793894e18f1fcbb2";
   Name     : constant String := "mpfr-" & Version;

   procedure Download;
   procedure Extract (Architecture : String);

end Mpfr;
