#!/usr/bin/env bash

mkdir build
cd build

# Needed for pybind installation
export DCGPY_BUILD_DIR=`pwd`


if [[ "$target_platform" == linux-64 ]]; then
    LDFLAGS="-lrt ${LDFLAGS}"
fi

# Install a Pybind11 version compatible with pagmo and audi
git clone https://github.com/pybind/pybind11.git
cd pybind11
git checkout 4f72ef846fe8453596230ac285eeaa0ce3278bb4
mkdir build
cd build
pwd
cmake \
    -DPYBIND11_TEST=NO \
    -DCMAKE_INSTALL_PREFIX=$DCGPY_BUILD_DIR \
    -DCMAKE_PREFIX_PATH=$DCGPY_BUILD_DIR \
    ..
make install
cd ../..

# Install the dcgp headers first.
cmake \
    -DBoost_NO_BOOST_CMAKE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DDCGP_BUILD_TESTS=no \
    -DDCGP_BUILD_EXAMPLES=no \
    ..

make -j${CPU_COUNT} VERBOSE=1

make install

cd ..
mkdir build_python
cd build_python

# Now the python bindings.
cmake \
    -DBoost_NO_BOOST_CMAKE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DDCGP_BUILD_DCGP=no \
    -DDCGP_BUILD_DCGPY=yes \
    -Dpybind11_DIR=$DCGPY_BUILD_DIR/share/cmake/pybind11/ \
    ..

make -j${CPU_COUNT} VERBOSE=1

make install
