# crosstooler
Builds Cross-Compiling GCC Toolchains for Alire

We use this application to build an Alire compatible cross-compiling
toolchain for a 64-bit ARM system running Linux. It could be expanded
to include other architectures in the future.

Requires [Alire](https://alire.ada.dev) to build and run.

To build:
```
alr build
```

Then to run using a configured Alire toolchain:
```
alr exec ./bin/crosstooler
```

Or, to also create a build log:
```
alr exec ./bin/crosstooler | tee build.log
```

Or, using the native toolchain from your Linux Distro:
```
./bin/crosstooler
```

All of the build files will be in the `ct-build` directory, and the
toolchains will be packaged up into tar files using then gnat- format
for use bt Alire.

## Using the toolchain

Once generated the toolchain needs to be made available to Alire using and
index. We have a [publicly avaliable index](https://github.com/ccxtechnologies/alire-index-public)
that you can use as an example, or can just link to if you want to use our
latest toolchain builds.

**Note that the build sysroot is hard coded in the toolchain, so if you try
to use this on a system that has a toochain at the full sysroot path your
builds with this toolchain will fail with errors about missing symbols.**
