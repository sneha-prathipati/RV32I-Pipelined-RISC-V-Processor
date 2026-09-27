# 32-bit 5-Stage Pipelined RV32I RISC-V Processor

A 32-bit five-stage pipelined RISC-V processor designed using **Verilog HDL** and developed, simulated, synthesized, and implemented using **Xilinx Vivado 2025.2**.

## Overview

This project implements a modular RV32I-based processor using a classic five-stage pipeline:

**IF → ID → EX → MEM → WB**

The processor includes pipeline registers, register-based computation, memory operations, data forwarding, hazard detection, instruction and data caches, branch handling, and performance monitoring.

## Architecture

The processor consists of:

- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)
- IF/ID pipeline register
- ID/EX pipeline register
- EX/MEM pipeline register
- MEM/WB pipeline register

Additional units include:

- ALU and ALU Control
- Register File
- Control Unit
- Immediate Generator
- Forwarding Unit
- Hazard Detection Unit
- Instruction Cache
- Data Cache
- Cache Controller
- Cache Refill
- Branch Predictor
- Performance Monitoring Units

## Key Features

- 32-bit RV32I architecture
- Five-stage pipelined datapath
- 32 × 32-bit register file
- ALU-based arithmetic and logical operations
- Immediate instruction support
- Load/store operations
- Instruction cache
- Data cache
- Cache hit/miss monitoring
- Data forwarding
- Hazard detection
- Pipeline stall and flush control
- Branch prediction and branch statistics
- CPI monitoring
- Verilog RTL implementation
- Vivado simulation
- RTL synthesis
- FPGA implementation
- Resource utilization analysis

## Test Program

The processor was verified using the following instructions:

| Instruction | Operation |
|---|---|
| `00500093` | ADDI x1, x0, 5 |
| `00A00113` | ADDI x2, x0, 10 |
| `002081B3` | ADD x3, x1, x2 |
| `40110233` | SUB x4, x2, x1 |
| `00302023` | SW x3, 0(x0) |
| `00002283` | LW x5, 0(x0) |

### Verification Results

| Register | Expected | Obtained |
|---|---:|---:|
| x1 | 5 | 5 |
| x2 | 10 | 10 |
| x3 | 15 | 15 |
| x4 | 5 | 5 |
| x5 | 15 | 15 |

**Processor Executed Successfully**

## Simulation Performance

| Parameter | Result |
|---|---:|
| Total Cycles | 50 |
| Instructions Retired | 46 |
| Stall Count | 0 |
| Flush Count | 0 |
| Instruction Cache Hits | 2 |
| Instruction Cache Misses | 48 |
| Data Cache Hits | 49 |
| Data Cache Misses | 1 |
| Branches | 50 |
| Correct Predictions | 50 |
| Mispredictions | 0 |
| CPI | 1 |

## FPGA Resource Utilization

The design was synthesized and implemented using Xilinx Vivado 2025.2.

| FPGA Resource | Used |
|---|---:|
| Slice LUTs | 487 |
| Slice Registers | 278 |
| Slices | 155 |
| LUT as Logic | 386 |
| LUT as Memory | 101 |
| Bonded IOB | 34 |
| BUFGCTRL | 1 |

Target device: **Xilinx 7A100T-class FPGA**

## Project Structure

```text
RV32I-Pipelined-RISC-V-Processor/
│
├── README.md
│
├── Verilog RTL
│   ├── Pipeline stages
│   ├── ALU and control
│   ├── Register file
│   ├── Hazard detection
│   ├── Forwarding
│   ├── Instruction cache
│   ├── Data cache
│   ├── Branch prediction
│   └── Performance monitoring
│
├── Testbench
│   └── tb_rv32i_pipeline.v
│
└── Documentation
    └── RV32I_5Stage_Pipelined_Processor_Detailed_Report.pdf
