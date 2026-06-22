# RV32I Processor Architecture

This repository contains a 32-bit RISC-V (RV32I) processor developed from a single-cycle datapath into a fully forwarded, stalled, and flushed 5-stage pipeline.

## 5-Stage Pipeline Implementation

The pipeline architecture strictly follows the classic RISC load-store design:

1. **Instruction Fetch (IF)**: PC logic, Instruction Memory, and Branch Target update.
2. **Instruction Decode (ID)**: Register File read, Control Unit decoding, and Immediate Generation.
3. **Execute (EX)**: ALU execution, Branch target calculation, and Branch resolution.
4. **Memory Access (MEM)**: Data Memory Read/Write.
5. **Writeback (WB)**: Register File update.

### Pipeline Registers
The boundaries between stages are synchronized using 4 distinct registers, preventing signals from leaking across clock boundaries:
* `IF/ID` Register (supports stalling and flushing)
* `ID/EX` Register (supports bubble insertion via synchronous zeroing)
* `EX/MEM` Register
* `MEM/WB` Register

## Instruction Support
The processor implements a verified subset of the RV32I Base Integer Instruction Set, covering arithmetic, memory, and control-flow operations:
* **Arithmetic/Logic (R-type)**: `ADD`, `SUB`, `AND`, `OR`
* **Immediate (I-type)**: `ADDI`
* **Memory (Load/Store)**: `LW`, `SW`
* **Control Flow**: `BEQ`, `BNE`, `JAL`

## Control Signals & Datapath
The `control.v` unit decodes standard 7-bit RISC-V opcodes to generate control lines (`reg_write`, `mem_read`, `alu_src`, etc.), which are then safely carried alongside data down the pipeline.
