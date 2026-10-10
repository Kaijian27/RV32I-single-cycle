# RISC-V Single-Cycle Processor (Verilog RTL)

A 32-bit single-cycle RISC-V processor implemented using Verilog HDL. This project demonstrates the fundamental datapath and control logic of a processor supporting a subset of the RV32I instruction set.

Each instruction is executed within a single clock cycle, including instruction fetch, decoding, execution, memory access (when required), and register write-back.

## Architecture

The processor consists of the following main components:

- **Program Counter (PC):** Stores the current instruction address and selects the next address.
- **Instruction Memory:** Stores 32-bit instructions and provides combinational instruction reads.
- **Instruction Decoder:** Extracts opcode, register addresses, function fields, and sign-extended immediate values.
- **Control Unit:** Generates control signals based on the instruction opcode.
- **Register File:** Contains 32 general-purpose 32-bit registers, with `x0` hardwired to zero for reads.
- **ALU:** Performs arithmetic, logical, and comparison operations.
- **Data Memory:** Supports synchronous writes and combinational reads.
- **Branch Logic:** Calculates the branch target and determines whether the PC should be updated to the branch address.

The datapath uses multiplexers to select ALU operands, register write-back data, and the next PC.

## Supported Instructions

| Instruction | Type | Description |
|---|---|---|
| `ADD` | R-type | Register addition |
| `SUB` | R-type | Register subtraction |
| `AND` | R-type | Bitwise AND |
| `OR` | R-type | Bitwise OR |
| `SLT` | R-type | Signed set-less-than comparison |
| `ADDI` | I-type | Add immediate |
| `LW` | I-type | Load word |
| `SW` | S-type | Store word |
| `BEQ` | B-type | Branch if equal |

This implementation supports the instructions listed above and is not a complete RV32I processor.

## Repository Structure

```text
RV32I-single-cycle/
├── rtl/
│   ├── alu.v
│   ├── alu_control.v
│   ├── alu_src_mux.v
│   ├── branch_adder.v
│   ├── control_unit.v
│   ├── data_memory.v
│   ├── instruction_decoder.v
│   ├── instruction_memory.v
│   ├── memtoreg_mux.v
│   ├── pc_adder.v
│   ├── pc_mux.v
│   ├── pc_reg.v
│   ├── register_file.v
│   └── riscv_cpu.v
├── tb/
│   └── tb_riscv.v
└── README.md
```

## Verification

The processor was tested using an Icarus Verilog directed testbench.

The testbench executes the following instruction sequence:

1. `addi x1, x0, 5` — Store 5 in x1.
2. `addi x2, x0, 3` — Store 3 in x2.
3. `add x3, x1, x2` — Calculate 5 + 3 = 8.
4. `sw x3, 0(x0)` — Store the result into data memory.
5. `lw x4, 0(x0)` — Load the stored value into x4.
6. `beq x3, x4, 8` — Branch when x3 equals x4.
7. `addi x5, x0, 99` — Skipped when the branch is taken.
8. `addi x6, x0, 1` — Execute the branch target instruction.

### Verified Results

| Verification | Expected Result |
|---|---|
| ADDI | x1 = 5, x2 = 3 |
| ADD | x3 = 8 |
| SW / LW | x4 = 8 |
| BEQ | PC jumps from `0x14` to `0x1C` |
| Branch target | x6 = 1 |

The self-checking testbench completed successfully:

```text
[PASS] BEQ branch taken correctly

[TEST PASSED] All CPU tests passed!
```

The testbench verifies this directed instruction sequence. Other implemented instructions and edge cases have not all been covered by the current test.

## Simulation

This project can be simulated using Icarus Verilog.

**1. Compile the RTL and testbench**

```bash
iverilog -g2012 -s tb_riscv -o riscv_sim rtl/*.v tb/tb_riscv.v
```

**2. Run simulation**

```bash
vvp riscv_sim
```

**3. Check the terminal output**

The simulation prints the PC progression and register values, followed by a PASS/FAIL result.

## Design Limitations

- Supports only a subset of RV32I instructions.
- Does not implement pipelining, forwarding, or hazard detection.
- Instruction and data memories are simplified behavioral models.
- Uninitialized register storage may appear as `X` in simulation; architectural reads of `x0` return zero.
- Verification currently covers a directed program rather than the complete instruction set.

## Project Scope

This project was developed for learning and practicing processor architecture, RTL design, module integration, and functional verification using Verilog HDL.

AI tools were used to assist with implementation and debugging. The design was studied and verified through simulation as part of the learning process.