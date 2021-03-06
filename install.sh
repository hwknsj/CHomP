#!/bin/bash
CUR_DIR=`pwd`
if [ $# -ge 1 ]; then
    # The user supplied an argument
    PREFIX=${1}
    # Get absolute path name of install directory
    mkdir -p "${PREFIX}" 2> /dev/null
    cd "${PREFIX}" > /dev/null 2>&1
    if [ $? != 0 ] ; then
        echo "ERROR: directory '${PREFIX}' does not exist nor could be created."
        echo "Please choose another directory."
        exit 1
    else
        PREFIX=`pwd -P`
    fi
    echo "CHomP will be installed in '${PREFIX}'"    
    ARGUMENT="-DCMAKE_INSTALL_PREFIX=${PREFIX} -DUSER_INCLUDE_PATH=${PREFIX}/include -DUSER_LIBRARY_PATH=${PREFIX}/lib"

fi

cd ${CUR_DIR}
rm -rf build
mkdir build
cd build
# Note: we pass `which g++` because apparently
#  CMake doesn't necessarily pick the compiler on the path
cmake -DCMAKE_CXX_COMPILER=`which g++` $ARGUMENT ..
make
make install
make test || echo "One or more tests failed.\n"

echo "For a graphical test, type: ./build/bin/chomp-greyscale-to-cubical .\
/examples/rubik.jpg 128 ./examples/rubik.cub"
