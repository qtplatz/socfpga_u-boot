#
cmake_minimum_required ( VERSION 3.7 )  # for GREATER_EQUAL
cmake_policy( SET CMP0020 NEW )
cmake_policy( SET CMP0042 NEW )
cmake_policy( SET CMP0053 NEW )

project ( socfpga_u-boot )

set ( CMAKE_EXPORT_COMPILE_COMMANDS ON )

if (NOT DEFINED CMAKE_SUPPRESS_DEVELOPER_WARNINGS)
  set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS 1 CACHE INTERNAL "No dev warnings")
endif()

list( APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules" )

get_filename_component( BUILD_ROOT ${CMAKE_BINARY_DIR} DIRECTORY )

#--- read config.sh ---
file( STRINGS ${CMAKE_SOURCE_DIR}/config.sh configs )
foreach( i ${configs} )
  string( REGEX MATCHALL "[^=]+=.+$" config ${i} )
  string( REGEX REPLACE "([^=]+)=(.+$)" "\\1" key ${i} )
  if ( ${key} MATCHES "^(KERNELRELEASE|BOOST_VERSION|distro|cross_target|target|target_device)$" )
    string( REGEX REPLACE "([^=]+)=(.+$)" "\\2" value ${i} )
    set( ${key} ${value} )
  endif()
endforeach()

#---------- find qtplatz-config.cmake --------------
set ( DKMS_PACKAGES "" )

set ( MAKE make )
set ( DOWNLOADS $ENV{HOME}/Downloads )
set ( UBOOT_BRANCH "v2018.05" )
set ( UBOOT_GITURL "git://git.denx.de/u-boot.git" )

set ( UBOOT_BUILD_DIR ${CMAKE_BINARY_DIR}/u-boot-${target_device} )
set ( TOOLS ${CMAKE_SOURCE_DIR}/scripts )

if ( CMAKE_CROSSCOMPILING )
  ###################### U-BOOT #########################
  set( UBOOT_PATCHES ${TOOLS}/u-boot-de0-nano-soc.patch )  # <-- default GENERALIO configuration
  include ( u-boot )
endif()

message( STATUS "--------------------------------------------" )
message( STATUS "UBOOT_BUILD_DIR = " ${UBOOT_BUILD_DIR} )
message( STATUS "distro          = " ${distro} )
message( STATUS "cross_target    = " ${cross_target} )
message( STATUS "target_device   = " ${target_device} )
message( STATUS "DOWNLOADS       = " ${DOWNLOADS} )
message( STATUS "CMAKE_BUILD_TYPE  = " ${CMAKE_BUILD_TYPE} )
message( STATUS "--------------------------------------------" )
