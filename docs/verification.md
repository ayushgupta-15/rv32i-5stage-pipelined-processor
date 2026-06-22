# Verification & Regression Infrastructure

This project employs an automated, scalable testbench infrastructure to ensure architectural correctness. Rather than simply viewing waveforms, tests make programmatic assertions against the final state of the Register File and Data Memory.

## Testbench Architecture (`tb_validation.v`)

A single, generic integration testbench dynamically loads parameterized machine code hex files (`$value$plusargs("+INIT_FILE=...")`) into the instruction memory, executes for a fixed number of cycles to allow pipeline drain, and verifies architectural state.

## Validation Suite

The regression suite is triggered via `make validate`, which iterates through edge-case programs:

| Test Name | File | Description | Expected Status |
|-----------|------|-------------|-----------------|
| `arith` | `arith.hex` | Tests `ADD`, `SUB`, `ADDI` forwarding hazards. | PASS |
| `memory` | `memory.hex` | Tests `LW`, `SW` with store-data forwarding. | PASS |
| `branch_taken` | `branch_taken.hex` | Tests `BEQ` flush logic. | PASS |
| `branch_not_taken` | `branch_not_taken.hex` | Tests `BNE` sequential fall-through. | PASS |
| `jal` | `jal.hex` | Tests unconditional jump flush logic. | PASS |
| `dependency` | `dependency.hex` | Deep RAW chaining (`x1` -> `x2` -> `x3`). | PASS |
| `mixed` | `mixed.hex` | Comprehensive program exercising all features. | PASS |
| `load_use` | `load_use.hex` | Tests 1-cycle pipeline stalling for `LW` hazards. | PASS |

## Methodology

This test suite was instrumental during the pipeline transition. 
1. The single-cycle processor passed all tests, establishing the baseline.
2. Pipeline registers were inserted, intentionally breaking `arith`, `branch`, and `memory` tests due to hazards.
3. Tests turned green one by one as Forwarding, Stalling, and Flushing units were successfully integrated.
