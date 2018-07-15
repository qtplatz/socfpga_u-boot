# socfpga_u-boot

CMake script for u-boot for de0-nano-soc

To initiate build directory, run ./bootstrap.sh bash script that create ./build directory and run cmake with cmake cross toolchain file.  The make command will fetch u-boot source from git.denx.de repo, and then automatically configure and build u-boot.
