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

# Tests are grouped by the library they exercise. The selected architecture
# (see the top-level CMakeLists.txt) determines which core library and which
# intrinsics library are under test, and therefore which test directories build.
# CORE_LIBRARY / INTRINSICS_LIBRARY are set by the top-level CMakeLists.txt and
# match both the submodule directory names and the test directory names here.

add_subdirectory(${CORE_LIBRARY})
add_subdirectory(${INTRINSICS_LIBRARY})
