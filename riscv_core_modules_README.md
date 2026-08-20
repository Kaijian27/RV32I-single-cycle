# RISC-V Single-Cycle Processor Core

This repository contains the complete implementation of a single-cycle RISC-V processor, including all necessary digital logic modules, data/instruction memories, and a testbench for verification.

## Repository Structure
- `rtl/`: Contains the Verilog source code for individual modules.
- `tb/`: Contains the testbench (`tb_riscv.v`) for simulation.

## Included Modules
1.  **`alu.v`**: Arithmetic Logic Unit (AND, OR, ADD, SUB, SLT).
2.  **`alu_control.v`**: ALU control signal decoder.
3.  **`alu_src_mux.v`**: Multiplexer for ALU input B.
4.  **`branch_adder.v`**: Branch target address calculator.
5.  **`control_unit.v`**: Main control logic for instruction decoding.
6.  **`data_memory.v`**: Data memory (synchronous write, combinational read).
7.  **`instr_decoder.v`**: Instruction decoder and immediate generator.
8.  **`instruction_memory.v`**: Instruction memory (combinational read).
9.  **`memtoreg_mux.v`**: Multiplexer for Write-Back data.
10. **`pc_adder.v`**: Program Counter increment logic (PC+4).
11. **`pc_mux.v`**: Next PC selection (PC+4 or Branch target).
12. **`pc_reg.v`**: Program Counter register.
13. **`register_file.v`**: 32x32-bit register file (x0 is hardwired to 0).
14. **`riscv_cpu.v`**: Top-level integration of all modules.

## Getting Started
To simulate this project, you can use Icarus Verilog:

1. **Compile**:
   `iverilog -o riscv_sim rtl/*.v tb/tb_riscv.v`
2. **Run Simulation**:
   `vvp riscv_sim`

## License
MIT
