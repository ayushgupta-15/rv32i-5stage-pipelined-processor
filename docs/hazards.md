# Pipeline Hazards & Mitigation Strategies

Transforming the datapath from single-cycle to 5-stage pipelined introduced structural, data, and control hazards. This document outlines how each hazard is detected and resolved in hardware.

## Read-After-Write (RAW) Data Hazards

When an instruction requires a register value that is currently being computed by a preceding instruction, the pipeline will naturally read stale data.

### Forwarding Unit Mitigation
The `forwarding_unit.v` prevents RAW hazards by bypassing the register file and redirecting intermediate EX or MEM outputs directly into the ALU.

**Example Scenario:**
```assembly
ADDI x1, x0, 5    # Computes x1 in EX
ADD  x2, x1, x1   # Reads x1 in ID
```
Without forwarding, `ADD` reads `x1=0`. With forwarding, `ADD`'s 3-way ALU Muxes select `forward_a = 2'b10`, pulling the computed `5` directly from the `EX/MEM` register.

The Forwarding Unit prioritizes the `EX/MEM` boundary over the `MEM/WB` boundary if consecutive instructions attempt to write to the same register.

### Register File Bypassing
If a write happens synchronously in `WB` at the exact same cycle it is being read in `ID`, the register file intrinsically forwards the data using an asynchronous internal bypass `(write_reg == read_reg) ? write_data : registers[read_reg]`.

## Load-Use Hazards

A load-use hazard occurs when a memory read (`LW`) is immediately followed by an arithmetic operation that requires the loaded value. Since memory is not read until the `MEM` stage, forwarding from `EX/MEM` is impossible.

**Example Scenario:**
```assembly
LW   x1, 0(x0)
ADD  x2, x1, x1
```

### Hazard Detection & Stalling Mitigation
The `hazard_detection_unit.v` detects if the instruction currently in `EX` is a memory read, and if its destination register matches either source register of the instruction currently in `ID`. 

If detected, the pipeline is stalled for 1 cycle:
1. `PC` write is disabled (prevents fetching a new instruction).
2. `IF/ID` write is disabled (holds the `ADD` instruction in Decode).
3. The `ID/EX` register control signals are zeroed out (injects a `NOP` bubble into Execute).

## Control Hazards

Branches (`BEQ`, `BNE`) and jumps (`JAL`) modify the Program Counter. Because our branch resolution happens in the `EX` stage, the pipeline blindly fetches instructions sequentially in the `IF` and `ID` stages before it knows if the branch was actually taken.

### Pipeline Flush Mitigation
When a branch or jump evaluates to true in `EX`, a `flush` signal is asserted.
1. The `IF/ID` register clears its instruction (converting it to a NOP).
2. The `ID/EX` register clears its control signals (injecting a bubble).
This effectively kills the two wrong-path instructions fetched during the branch delay slots, restoring architectural correctness.
