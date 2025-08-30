# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Project F is an educational FPGA development repository focused on graphics, mathematics, and hardware design using SystemVerilog. The project emphasizes vendor-neutral, beginner-friendly designs that work across multiple FPGA architectures (XC7, iCE40, ECP5).

## Repository Structure

- **graphics/** - FPGA graphics tutorials and designs (pong, sprites, framebuffers, etc.)
- **lib/** - Verilog library with reusable modules organized by function:
  - `lib/essential/` - core utilities for most designs
  - `lib/display/` - display timings, framebuffer, DVI/HDMI
  - `lib/graphics/` - drawing primitives (lines, shapes)
  - `lib/maths/` - mathematical functions (division, square root, LFSR)
  - `lib/memory/` - ROM/RAM designs including BRAM
  - `lib/clock/` - clock generation and domain crossing
- **demos/** - Complete demonstration projects
- **hello/** - Beginner FPGA tutorials
- **maths/** - Mathematical algorithm implementations

## Build System

Each project uses Makefiles for building and simulation:

### Simulation (Verilator)
- Navigate to project's `sim/` directory
- Run `make` to build the simulation
- Example: `cd graphics/pong/sim && make`

### FPGA Synthesis
- Navigate to target FPGA directory (`ice40/`, `xc7/`, `ecp5/`)
- Run `make` to synthesize for target FPGA
- Example: `cd graphics/pong/ice40 && make`

### Testing
- Library tests in `lib/maths/test/`: run `make all` for comprehensive tests
- Individual test targets: `make div`, `make mul`, etc.

## Development Guidelines

### SystemVerilog Style
- Use `logic` instead of `wire`/`reg`
- Use `always_comb` and `always_ff` for clear intent
- Use `$clog2` for address width calculations
- Use `enum` for finite state machines
- Use matching names in module instances: `.clk_pix` vs `.clk_pix(clk_pix)`

### Linting
All designs must pass Verilator lint:
```bash
verilator --lint-only -Wall <file.sv>
```

### Library Dependencies
- Most designs depend on `lib/essential/` - include with `-I../../../lib/essential`
- Graphics projects often need additional lib paths like `lib/display/`, `lib/graphics/`
- Check existing Makefiles for proper include paths

### FPGA Architecture Support
- XC7 (Xilinx 7-series): Uses `BUFG`, `MMCME2_BASE`, `OBUFDS`, `OSERDES2`
- iCE40 (Lattice): Uses `SB_IO`, `SB_PLL40_PAD`, `SB_SPRAM256KA`
- ECP5 (Lattice): Uses `EHXPLLL`, `ODDRX1F`
- Designs should be vendor-neutral when possible

## Common Patterns

### Project Structure
- `rtl/` or root: SystemVerilog source files
- `sim/`: Verilator simulation with SDL2 for graphics
- `ice40/`, `xc7/`, `ecp5/`: FPGA-specific synthesis
- `res/`: Resource files (.mem files for ROMs, images, etc.)

### Typical Build Flow
1. Verilator generates C++ from SystemVerilog
2. C++ compiled with SDL2 for graphics simulation
3. For FPGA: synthesis tools (Yosys, Vivado) generate bitstream

### Module Includes
Most projects follow this pattern:
```systemverilog
// Project F Library includes
`include "path/to/lib/essential/essential.svh"
```