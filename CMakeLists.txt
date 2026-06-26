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
    DESCRIPTION "Tests for the Embedded Society's ARM Cortex-M libraries"
    HOMEPAGE_URL "https://github.com/embedded-society/arm-cortex-mx-core-tests"
)

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
    message(FATAL_ERROR "Missing target ARM Cortex-M architecture for which to build the tests")
endif()

if(NOT ARM_CORTEX_M_ARCH IN_LIST AVAILABLE_ARM_CORTEX_M_ARCHS)
    message(FATAL_ERROR "Unsupported ARM Cortex-M architecture: ${ARM_CORTEX_M_ARCH}")
endif()

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

if(ARM_CORTEX_M_ARCH STREQUAL "M0")
    target_compile_definitions(${PROJECT_NAME} INTERFACE ARM_CORTEX_M0)
    target_compile_options(${PROJECT_NAME} INTERFACE -mcpu=cortex-m0)
    target_link_options(${PROJECT_NAME} INTERFACE -mcpu=cortex-m0)
elseif(ARM_CORTEX_M_ARCH STREQUAL "M0PLUS")
    target_compile_definitions(${PROJECT_NAME} INTERFACE ARM_CORTEX_M0PLUS)
    target_compile_options(${PROJECT_NAME} INTERFACE -mcpu=cortex-m0plus)
    target_link_options(${PROJECT_NAME} INTERFACE -mcpu=cortex-m0plus)
elseif(ARM_CORTEX_M_ARCH STREQUAL "M1")
    target_compile_definitions(${PROJECT_NAME} INTERFACE ARM_CORTEX_M1)
    target_compile_options(${PROJECT_NAME} INTERFACE -mcpu=cortex-m1)
    target_link_options(${PROJECT_NAME} INTERFACE -mcpu=cortex-m1)
elseif(ARM_CORTEX_M_ARCH STREQUAL "M3")
    target_compile_definitions(${PROJECT_NAME} INTERFACE ARM_CORTEX_M3)
    target_compile_options(${PROJECT_NAME} INTERFACE -mcpu=cortex-m3)
    target_link_options(${PROJECT_NAME} INTERFACE -mcpu=cortex-m3)
endif()

if(ARM_CORTEX_M_ARCH STREQUAL "M0")
    add_subdirectory("arm-cortex-m0-core")
    add_subdirectory("armv6m-intrinsics")
elseif(ARM_CORTEX_M_ARCH STREQUAL "M0PLUS")
    add_subdirectory("arm-cortex-m0plus-core")
    add_subdirectory("armv6m-intrinsics")
elseif(ARM_CORTEX_M_ARCH STREQUAL "M1")
    add_subdirectory("arm-cortex-m1-core")
    add_subdirectory("armv6m-intrinsics")
elseif(ARM_CORTEX_M_ARCH STREQUAL "M3")
    add_subdirectory("arm-cortex-m3-core")
    add_subdirectory("armv7m-intrinsics")
endif()

include(CTest)
add_subdirectory(tests)
