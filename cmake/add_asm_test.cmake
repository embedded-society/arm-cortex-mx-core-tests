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

# add_asm_test(<test_name> <library_target>)
#
# Builds <test_name>.cpp as a STATIC library linked against <library_target>,
# disassembles it with objdump, and registers a CTest that runs LLVM FileCheck
# over the disassembly using the directives embedded in <test_name>.cpp.
#
# FileCheck prefixes: the generic CHECK plus a per-configuration prefix
# (DEBUG-CHECK / MINSIZE-CHECK / MAXSPEED-CHECK) so a single test source can
# assert different expected code generation per optimization level.
function(add_asm_test TEST_NAME LIBRARY_TARGET)
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
