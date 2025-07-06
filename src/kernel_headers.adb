--  Copyright 2025, CCX Technologies

with Builder;
with Logger;

package body Kernel_Headers is
   package Log is new Logger ("kernel-headers");

   Filename : constant String := Name & ".tar.xz";
   Url : constant String := "https://cdn.kernel.org/pub/linux/kernel/v6.x";

   function Kernel_Architecture (Architecture : String) return String is
   begin
      if Architecture = "aarch64-linux-gnu" then
         return "arm64";
      else
         raise Constraint_Error with "Unknown Architecture: " & Architecture;
      end if;
   end Kernel_Architecture;

   procedure Download is
   begin
      Log.Info ("Downloading...");
      Builder.Download (Filename, Url, Checksum);
   end Download;

   procedure Extract (Architecture : String) is
   begin
      Log.Info ("Extracting...");
      Builder.Extract (Filename, Architecture);
   end Extract;

   procedure Install (Gnat_Package_Name : String; Architecture : String) is
   begin
      Log.Info ("Installing Version " & Version & " ...");

      --  TODO: See if we really need to install in both locations

      Builder.Make_In_Place
        (Name, Architecture, "headers_install",
         "ARCH=" & Kernel_Architecture (Architecture) & " INSTALL_HDR_PATH=" &
         Builder.Sysroot_Directory (Gnat_Package_Name, Architecture));

      Builder.Install_In_Place
        (Name, Architecture, "headers_install",
         "ARCH=" & Kernel_Architecture (Architecture) & " INSTALL_HDR_PATH=" &
         Builder.Toolchain_Directory (Gnat_Package_Name));
   end Install;

end Kernel_Headers;
