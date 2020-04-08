mkdir build
cd build

SET DCGPY_BUILD_DIR=%cd%

git clone https://github.com/pybind/pybind11.git
cd pybind11
git checkout 4f72ef846fe8453596230ac285eeaa0ce3278bb4
mkdir build
cd build
cmake ^
    -G "Ninja" ^
    -DPYBIND11_TEST=NO ^
    -DCMAKE_INSTALL_PREFIX=%DCGPY_BUILD_DIR% ^
    -DCMAKE_PREFIX_PATH=%DCGPY_BUILD_DIR% ^
    -DCMAKE_BUILD_TYPE=Release ^
    ..
cmake --build . --target install
cd ../..

cmake ^
    -G "Ninja" ^
    -DCMAKE_C_COMPILER=clang-cl ^
    -DCMAKE_CXX_COMPILER=clang-cl ^
    -DBoost_NO_BOOST_CMAKE=ON ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DDCGP_BUILD_TESTS=no ^
    -DDCGP_BUILD_EXAMPLES=no ^
    ..

cmake --build . -- -v

cmake --build . --target install

cd ..
mkdir build_python
cd build_python

cmake ^
    -G "Ninja" ^
    -DCMAKE_C_COMPILER=clang-cl ^
    -DCMAKE_CXX_COMPILER=clang-cl ^
    -DBoost_NO_BOOST_CMAKE=ON ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DDCGP_BUILD_DCGP=no ^
    -DDCGP_BUILD_DCGPY=yes ^
    "-DDCGP_CXX_FLAGS_EXTRA=-D_copysign=copysign" ^
    -Dpybind11_DIR=%DCGPY_BUILD_DIR%\share\cmake\pybind11\ ^
    ..

cmake --build . -- -v

cmake --build . --target install
