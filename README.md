# RISC-V Pipeline

A 5-stage pipelined RV32I RISC-V processor implemented in Verilog.

## Project Structure

```
riscv-pipeline/
│
├── rtl/
│   ├── components/         ← 8 leaf modules (alu, reg_file, imm_gen, etc.)
│   ├── pipeline/           ← 4 pipeline registers (if_id, id_ex, ex_mem, mem_wb)
│   ├── hazard/             ← forwarding_unit, hazard_detection
│   └── riscv_pipeline.v    ← top-level, instantiates everything
│
├── tb/
│   ├── unit/               ← one testbench per leaf module
│   └── integration/        ← tb_single_cycle.v, tb_pipeline.v
│
├── programs/
│   ├── src/                ← .s assembly source files
│   ├── hex/                ← compiled .hex files loaded by testbench
│   └── expected/           ← hand-calculated expected register outputs
│
├── sim/
│   ├── waves/              ← .vcd waveform dumps (opened in GTKWave)
│   └── logs/               ← simulation stdout logs
│
├── vivado/
│   ├── constraints/        ← clock .xdc file
│   └── reports/            ← synthesis + timing report screenshots
│
├── docs/
│   └── waveforms/          ← screenshots for README (hazard scenarios)
│
└── Makefile                ← iverilog compile + vvp run commands
```

## Running Tests

To run the unit tests for a specific module, use the `Makefile`:

```bash
make test_alu
```

## Clean Simulation Files

Simulation outputs (binaries, logs, and waveforms) are placed in the `sim/` directory and should not be tracked by version control. To clean them:

```bash
make clean
```
