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

function(add_asm_test LIBRARY_TARGET TEST_NAME)
    add_library(${TEST_NAME} STATIC
        ${TEST_NAME}.cpp
    )

    target_link_libraries(${TEST_NAME} PRIVATE
        ${LIBRARY_TARGET}
    )

    add_custom_target(${TEST_NAME}_asm
        ALL
        WORKING_DIRECTORY "$<TARGET_FILE_DIR:${TEST_NAME}>"
        COMMAND "${CMAKE_COMMAND}" -E rm -f ${TEST_NAME}.asm
        COMMAND "${CMAKE_OBJDUMP}" -d --no-show-raw-insn ${CMAKE_STATIC_LIBRARY_PREFIX}${TEST_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX} > ${TEST_NAME}.asm
        BYPRODUCTS ${TEST_NAME}.asm
        VERBATIM
        DEPENDS ${TEST_NAME}
    )

    add_test(
        NAME ${TEST_NAME}
        COMMAND filecheck "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_NAME}.cpp" --input-file "$<TARGET_FILE_DIR:${TEST_NAME}>/${TEST_NAME}.asm"
            --check-prefixes=CHECK,$<UPPER_CASE:$<CONFIG>>-CHECK --allow-unused-prefixes
    )
endfunction()

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
