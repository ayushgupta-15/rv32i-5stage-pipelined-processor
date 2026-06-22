# Pipeline Timing Diagrams

The following diagrams illustrate how the processor mitigates hazards by altering the normal 5-stage pipeline timing.

## Read-After-Write (RAW) Hazard Mitigation

### Without Forwarding (Failure Case)
```assembly
ADDI x1, x0, 5
ADD  x2, x1, x1
```
| Instruction | Cycle 1 | Cycle 2 | Cycle 3 | Cycle 4 | Cycle 5 | Cycle 6 |
|-------------|---------|---------|---------|---------|---------|---------|
| `ADDI x1`   | IF      | ID      | EX      | MEM     | WB (x1) |         |
| `ADD x2`    |         | IF      | ID (x1=0) | EX      | MEM     | WB      |

*The `ADD` instruction reads the register file in ID (Cycle 3), but `x1` isn't written until WB (Cycle 5).*

### With Forwarding (Success Case)
```assembly
ADDI x1, x0, 5
ADD  x2, x1, x1
```
| Instruction | Cycle 1 | Cycle 2 | Cycle 3 | Cycle 4 | Cycle 5 | Cycle 6 |
|-------------|---------|---------|---------|---------|---------|---------|
| `ADDI x1`   | IF      | ID      | EX (x1=5)| MEM    | WB      |         |
| `ADD x2`    |         | IF      | ID      | EX (fw) | MEM     | WB      |

*In Cycle 4, the `ADD` instruction in EX bypasses the register file and directly consumes the output of the `EX/MEM` register via the Forwarding Unit.*

## Load-Use Hazard Mitigation

### Load-Use Stall & Bubble Injection
```assembly
LW   x1, 0(x0)
ADD  x2, x1, x1
```
| Instruction | Cycle 1 | Cycle 2 | Cycle 3 | Cycle 4 | Cycle 5 | Cycle 6 | Cycle 7 |
|-------------|---------|---------|---------|---------|---------|---------|---------|
| `LW x1`     | IF      | ID      | EX      | MEM (x1)| WB      |         |         |
| `ADD x2`    |         | IF      | ID      | ID (stall)| EX (fw) | MEM     | WB      |
| `Bubble`    |         |         |         | EX      | MEM     | WB      |         |

*In Cycle 3, the Hazard Detection Unit detects that `LW` in EX writes to `x1`, which `ADD` in ID requires. In Cycle 4, the `ADD` instruction is stalled in ID, and a `NOP` bubble is injected into EX. In Cycle 5, `ADD` enters EX and receives the loaded value via forwarding from `MEM/WB`.*

## Control Hazard Mitigation

### Branch Taken Flush
```assembly
BEQ  x1, x2, label
ADDI x3, x0, 99    # Wrong path
ADDI x4, x0, 42    # Wrong path
...
label:
SUB  x5, x1, x2
```

| Instruction | Cycle 1 | Cycle 2 | Cycle 3 | Cycle 4 | Cycle 5 |
|-------------|---------|---------|---------|---------|---------|
| `BEQ`       | IF      | ID      | EX (Taken)| MEM   | WB      |
| `ADDI x3`   |         | IF      | ID (Flushed)| -     | -       |
| `ADDI x4`   |         |         | IF (Flushed)| -     | -       |
| `SUB x5`    |         |         |         | IF      | ID      |

*In Cycle 3, the `BEQ` instruction resolves as Taken in the EX stage. The pipeline immediately flushes the wrong-path instructions (`ADDI x3` in ID and `ADDI x4` in IF) and begins fetching the correct target (`SUB x5`) in Cycle 4.*
