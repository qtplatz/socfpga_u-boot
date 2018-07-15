#!/bin/bash
cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
arch=`uname`-`arch`
host_system=`uname`
source $cwd/config.sh

source_dir=("$cwd")
build_debug=false
build_clean=false
build_root=$(dirname "$cwd")
config=release
cmake_args=('-DCMAKE_BUILD_TYPE=Release')
echo "Using Linux " $KERNELRELEASE

if [ $cwd = `pwd` ]; then
	build_dir=$cwd/build
else
	build_dir=`pwd`
fi

echo "source_dir       : ${source_dir}"
echo "build_dir        : ${build_dir}"
echo "target           :" $cross_target

# =============== change directory ==============

echo "#" mkdir -p $build_dir
echo "#" cd $build_dir
echo "cd ${build_dir}; cmake -DKERNELRELEASE=$KERNELRELEASE ${source_dir}"

if [ ! -d $build_dir ]; then
	mkdir -p $build_dir
fi

cd $build_dir
echo "#" pwd `pwd`

if [ -z $cross_target ]; then
    cmake "${cmake_args[@]}" $source_dir
else
    echo "## Cross build for $arch"
    case $cross_target in
		armhf|helio|de0-nano-soc|arm-linux-gnueabihf)
			echo cmake "${cmake_args[@]}" "..."
			cmake "${cmake_args[@]}" \
				  -DCMAKE_TOOLCHAIN_FILE=${cwd}/toolchain-arm-linux-gnueabihf.cmake \
				  -DKERNELRELEASE=$KERNELRELEASE \
				  $source_dir
			;;
		*)
			echo "Unknown cross_target: $cross_target"
			;;
    esac    
fi

