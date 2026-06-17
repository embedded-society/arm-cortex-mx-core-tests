# Copyright (C) 2026 The Embedded Society <https://github.com/embedded-society/arm-cortex-mx-core-tests>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.13)

project(arm-cortex-mx-core-tests
    LANGUAGES CXX
    VERSION 0.1.0
    DESCRIPTION "Tests for the Embedded Society arm-cortex-mx core and intrinsics libraries"
    HOMEPAGE_URL "https://github.com/embedded-society/arm-cortex-mx-core-tests"
)

# --- Target ARM Cortex-M architecture selection -----------------------------

set(AVAILABLE_ARM_CORTEX_M_ARCHS
    "M0"
    "M0PLUS"
    "M1"
    "M3"
)

if(NOT DEFINED ARM_CORTEX_M_ARCH)
    set(ARM_CORTEX_M_ARCH "" CACHE STRING "The target ARM Cortex-M architecture to build the tests for")
    set_property(CACHE ARM_CORTEX_M_ARCH PROPERTY STRINGS ${AVAILABLE_ARM_CORTEX_M_ARCHS})
endif()

if(NOT ARM_CORTEX_M_ARCH)
    message(FATAL_ERROR "Missing target ARM Cortex-M architecture (pass -DARM_CORTEX_M_ARCH=<arch> or use a preset)")
endif()

if(NOT ARM_CORTEX_M_ARCH IN_LIST AVAILABLE_ARM_CORTEX_M_ARCHS)
    message(FATAL_ERROR "Unsupported ARM Cortex-M architecture: ${ARM_CORTEX_M_ARCH}")
endif()

# --- Build configurations ---------------------------------------------------

get_property(IS_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

set(SUPPORTED_BUILD_TYPES
    Debug
    MinSize
    MaxSpeed
)

set(CMAKE_CXX_FLAGS_DEBUG "-Og -g")
set(CMAKE_CXX_FLAGS_MINSIZE "-Os")
set(CMAKE_CXX_FLAGS_MAXSPEED "-O3")

if(IS_MULTI_CONFIG)
    set(CMAKE_CONFIGURATION_TYPES "${SUPPORTED_BUILD_TYPES}" CACHE STRING "" FORCE)
    set(CMAKE_DEFAULT_BUILD_TYPE "MinSize" CACHE STRING "" FORCE)
else()
    if(NOT CMAKE_BUILD_TYPE)
        message(FATAL_ERROR "CMake build type not set")
    endif()

    if(NOT CMAKE_BUILD_TYPE IN_LIST SUPPORTED_BUILD_TYPES)
        message(FATAL_ERROR "Unsupported CMake build type: ${CMAKE_BUILD_TYPE}")
    endif()
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# --- Architecture -> CPU flag + libraries under test ------------------------

if(ARM_CORTEX_M_ARCH STREQUAL "M0")
    set(ARM_CPU_FLAG "-mcpu=cortex-m0")
    set(CORE_LIBRARY "arm-cortex-m0-core")
    set(INTRINSICS_LIBRARY "armv6m-intrinsics")
elseif(ARM_CORTEX_M_ARCH STREQUAL "M0PLUS")
    set(ARM_CPU_FLAG "-mcpu=cortex-m0plus")
    set(CORE_LIBRARY "arm-cortex-m0plus-core")
    set(INTRINSICS_LIBRARY "armv6m-intrinsics")
elseif(ARM_CORTEX_M_ARCH STREQUAL "M1")
    set(ARM_CPU_FLAG "-mcpu=cortex-m1")
    set(CORE_LIBRARY "arm-cortex-m1-core")
    set(INTRINSICS_LIBRARY "armv6m-intrinsics")
elseif(ARM_CORTEX_M_ARCH STREQUAL "M3")
    set(ARM_CPU_FLAG "-mcpu=cortex-m3")
    set(CORE_LIBRARY "arm-cortex-m3-core")
    set(INTRINSICS_LIBRARY "armv7m-intrinsics")
endif()

# The shared arm-cmake-toolchains deliberately do NOT set -mcpu/-mthumb (they
# stay reusable across all Cortex cores), so the tests supply the CPU flag here.
add_compile_options(${ARM_CPU_FLAG})
add_link_options(${ARM_CPU_FLAG})

# Libraries under test are git submodules checked out at the repository root.
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/${CORE_LIBRARY}"
    "${CMAKE_CURRENT_BINARY_DIR}/libs/${CORE_LIBRARY}")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/${INTRINSICS_LIBRARY}"
    "${CMAKE_CURRENT_BINARY_DIR}/libs/${INTRINSICS_LIBRARY}")

# --- Tests ------------------------------------------------------------------

include(CTest)
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/add_asm_test.cmake")

add_subdirectory(tests)
