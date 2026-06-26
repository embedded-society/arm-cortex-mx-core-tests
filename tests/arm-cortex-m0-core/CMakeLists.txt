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

add_asm_test(arm-cortex-m0-core test_special_regs)
add_asm_test(arm-cortex-m0-core test_nvic)
add_asm_test(arm-cortex-m0-core test_scb)
add_asm_test(arm-cortex-m0-core test_systick)
add_asm_test(arm-cortex-m0-core test_is_bit_set_compiletime)
add_asm_test(arm-cortex-m0-core test_is_bit_set_runtime)
add_asm_test(arm-cortex-m0-core test_set_bit_compiletime)
add_asm_test(arm-cortex-m0-core test_set_bit_runtime)
add_asm_test(arm-cortex-m0-core test_clear_bit_compiletime)
add_asm_test(arm-cortex-m0-core test_clear_bit_runtime)
