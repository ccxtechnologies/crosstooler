# crosstooler
A tool that builds Cross-Compiling GCC/GNAT Toolchains for Alire (for Ada).

We use this application to build Alire compatible cross-compiling
toolchains for a 64-bit ARM system running Linux (aarch64-linux) and
barebones (aarch64-elf). It could be expanded to include other
architectures in the future.

The toolchains include C and C++ compilers (and a relavent libc and Ada runtime)
but are primarily intended for building Ada applications.

[Alire](https://alire.ada.dev) is used to build and run the crosstooler tool.

The generated toolchains can be used on their own but are really intended to be loaded
and used with Alire.

The crosstooler application is intended to run on a Linux host system and may not
work on other platforms.

To build:
```
alr build
```

Then to run and build the toolchain, using a configured Alire toolchain:
```
alr exec ./bin/crosstooler
```

Or, to also create a build log:
```
alr exec ./bin/crosstooler 2>&1 | tee build.log
```

Or, using the native toolchain from your Linux Distro to build the toolchain
instead of the one from Alire, but Alire is still recomended to build tool:
```
./bin/crosstooler
```

All of the build files will be in the `ct-build` directory, and the
toolchains will be packaged up into tar files using then `gnat-...` naming
convention for use by Alire.

## Using the toolchain

Once generated the toolchain needs to be made available to Alire using an
index. We have a [publicly avaliable index](https://github.com/ccxtechnologies/alire-index-public)
that you can use as an example, or can just link to if you want to use our
latest toolchain builds and not build your own.

**Note that the build sysroot directory is unfortunatly hard coded into the toolchain during the
gcc build process; so if you try to use this toolchain on the same system that you built
your toolchain on you will need to delete the ct-build directory first, otherwise building
applicatoins with these toolchains may fail with errors about missing symbols.**
