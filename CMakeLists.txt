# Minimum CMake version
cmake_minimum_required(VERSION 3.15)

# Project name and language
project(gen_test_gzip C)

# Set output directory for binaries
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

# Vcpkg toolchain
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
	set(CMAKE_TOOLCHAIN_FILE "C:/vcpkg/scripts/buildsystems/vcpkg.cmake" CACHE STRING "Vcpkg toolchain file")
endif()

# Find zlib (via vcpkg)
find_package(ZLIB REQUIRED)

# Source file
add_executable(gen_test_gzip main.c)

# Link zlib
target_link_libraries(gen_test_gzip PRIVATE ZLIB::ZLIB)
