###################### U-BOOT #########################

add_custom_command(
  OUTPUT ${UBOOT_BUILD_DIR}/Makefile
  COMMAND git clone -b ${UBOOT_BRANCH} --single-branch --depth 1 ${UBOOT_GITURL} ${UBOOT_BUILD_DIR}
  )

add_custom_command(
  OUTPUT ${UBOOT_BUILD_DIR}/include/configs/socfpga_common.h.orig
  COMMENT "Apply patches"
  COMMAND ${TOOLS}/apply-patch.sh ${UBOOT_PATCHES}
  DEPENDS ${UBOOT_BUILD_DIR}/Makefile
  WORKING_DIRECTORY ${UBOOT_BUILD_DIR}
  )

add_custom_command( 
  OUTPUT ${UBOOT_BUILD_DIR}/u-boot-with-spl.sfp
  COMMAND ${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- socfpga_de0_nano_soc_defconfig
  COMMAND ${MAKE} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
  DEPENDS ${UBOOT_BUILD_DIR}/include/configs/socfpga_common.h.orig
  WORKING_DIRECTORY ${UBOOT_BUILD_DIR}  
)

add_custom_target( u-boot ALL DEPENDS ${UBOOT_BUILD_DIR}/u-boot-with-spl.sfp )

###################### end u-boot #######################
