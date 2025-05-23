# Beginning FPGA Graphics

This folder accompanies the Project F blog post: **[Beginning FPGA Graphics](https://projectf.io/posts/fpga-graphics/)**. These SystemVerilog designs introduce you to displays and demonstrate how to draw your first FPGA graphics. You can freely build on these [MIT licensed](../../LICENSE) designs. Have fun.

File layout:

* `ecp5` - designs for ULX3S and other Lattice ECP5 boards with DVI output
* `ice40` - designs for iCEBreaker and other Lattice iCE40 boards
* `sim` - simulation with Verilator and LibSDL; see the [Simulation README](sim/README.md)
* `xc7` - designs for Arty and other Xilinx 7 Series boards with VGA output
* `xc7-dvi` - designs for Nexys Video and other Xilinx 7 Series boards with DVI output

These designs make use of modules from the [Project F library](../../lib/).

Jump to build instructions for: [Arty](#arty-build) | [iCEBreaker](#icebreaker-build) | [Nexys Video](#nexys-video-build) | [ULX3S](#ulx3s-build) | [Verilator](sim/README.md)

## Demos

* Square - `square`
* Flag of Ethiopia - `flag_ethiopia`
* Flag of Sweden - `flag_sweden`
* Colour - `colour`

Learn more about the designs and demos from _[Beginning FPGA Graphics](https://projectf.io/posts/fpga-graphics/)_, or read on for build instructions.

![](../../doc/img/flag_ethiopia.png?raw=true "")

_Traditional flag of Ethiopia running as a Verilator simulation._

## Arty Build

To create a Vivado project for the Digilent Arty ([original](https://digilent.com/reference/programmable-logic/arty/reference-manual) or [A7-35T](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/reference-manual)); clone the projf-explore git repo, then start Vivado and run the following in the Tcl console:

```tcl
cd projf-explore/graphics/fpga-graphics/xc7/vivado
source ./create_project.tcl
```

You can then build the designs as you would for any Vivado project. These designs run at 640x480 on the Arty.

### Tested Versions

The Arty designs have been tested with:

* Vivado 2022.2

### Behavioural Simulation

This design includes test benches for the `clock_480p` and `simple_480p` modules. You can run the test bench simulations from the GUI under the "Flow" menu or from the Tcl Console with:

```tcl
launch_simulation
run all
```

By default, the `simple_480p` test bench is run, but you can switch to the `clock_tb` test bench using the GUI or from the Tcl console:

```tcl
set fs_sim_obj [get_filesets sim_1]
set_property -name "top" -value "clock_tb" -objects $fs_sim_obj
relaunch_sim
run all
```

### Other Xilinx 7 Series Boards

It's straightforward to adapt the project for other Xilinx 7 Series boards:

1. Create a suitable constraints file named `<board>.xdc` within the `xc7` directory
2. Make a note of your board's FPGA part, such as `xc7a35ticsg324-1L`
3. Set the board and part names in Tcl, then source the create project script:

```tcl
set board_name <board>
set fpga_part <fpga-part>
cd projf-explore/graphics/fpga-graphics/xc7/vivado
source ./create_project.tcl
```

Replace `<board>` and `<fpga-part>` with the actual board and part names.

## iCEBreaker Build

You can build projects for [iCEBreaker](https://docs.icebreaker-fpga.org/hardware/icebreaker/) using the included [Makefile](ice40/Makefile) with [Yosys](https://yosyshq.net/yosys/), [nextpnr](https://github.com/YosysHQ/nextpnr), and [IceStorm Tools](https://github.com/YosysHQ/icestorm).

You can get pre-built binaries for Linux, Mac, and Windows from [YosysHQ OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build).

Once the tools are installed, it's straightforward to build the designs.

For example, to build `flag_ethiopia`; clone the projf-explore git repo, then:

```shell
cd projf-explore/graphics/fpga-graphics/ice40
make flag_ethiopia
```

After the build completes, you'll have a bin file, such as `flag_ethiopia.bin`. Use the bin file to program your board:

```shell
iceprog flag_ethiopia.bin
```

If you get the error `Can't find iCE FTDI USB device`, try running `iceprog` with `sudo`.

These designs run at 640x480 on the iCEBreaker.

### Tested Versions

The iCE40 designs have been tested with:

* OSS CAD Suite 2023-03-01

## Nexys Video Build

To create a Vivado project for the Digilent [Nexys Video](https://digilent.com/reference/programmable-logic/nexys-video/reference-manual); clone the projf-explore git repo, then start Vivado and run the following in the Tcl console:

```tcl
cd projf-explore/graphics/fpga-graphics/xc7-dvi/vivado
source ./create_project.tcl
```

You can then build the designs as you would for any Vivado project. These designs run at 1280x720 on the Nexys Video.

### Tested Versions

The Nexys Video designs have been tested with:

* Vivado 2022.2

## ULX3S Build

I have tested these designs with recent (early 2024) versions of Yosys and nextpnr. You can get pre-built binaries for Linux, Mac, and Windows from [YosysHQ OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build).

Once the tools are installed, it's straightforward to build the designs.

For example, to build `square`; clone the projf-explore git repo, check the correct FPGA model is set near the top of `projf-explore/graphics/fpga-graphics/ecp5/Makefile` then:

```shell
cd projf-explore/graphics/fpga-graphics/ecp5
make square
```

After the build completes, you'll have a bit file, such as `square.bit`. Use the bit file to program your board:

```shell
openFPGALoader --board=ulx3s square.bit
```

These designs run at 1280x720 on the ULX3S.

### Board Programming without Root

Allow non-root Linux users to program the ULX3S by creating `/etc/udev/rules.d/80-fpga-ulx3s.rules` with the following:

```shell
# usb-serial tty device
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
# ujprog libusb access
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", GROUP="dialout", MODE="666"
```

You need to reinsert the USB cable for the new udev config to take effect.

## Verilator SDL Simulation

You can simulate these designs on your computer using Verilator and SDL. The [Simulation README](sim/README.md) has build instructions.

## Linting

If you have [Verilator](https://www.veripool.org/wiki/verilator) installed, you can run the linting shell script `lint.sh` to check the designs:

```shell
$ ./fpga-graphics/lint.sh
## Linting top modules in ./sim
##   Checking ./sim/top_colour.sv
##   Checking ./sim/top_flag_ethiopia.sv
##   Checking ./sim/top_flag_sweden.sv
##   Checking ./sim/top_square.sv
## Linting top modules in ./ice40
##   Checking ./ice40/top_colour.sv
##   Checking ./ice40/top_flag_ethiopia.sv
##   Checking ./ice40/top_flag_sweden.sv
##   Checking ./ice40/top_square.sv
## Linting top modules in ./xc7
##   Checking ./xc7/top_colour.sv
##   Checking ./xc7/top_flag_ethiopia.sv
##   Checking ./xc7/top_flag_sweden.sv
##   Checking ./xc7/top_square.sv
## Linting top modules in ./xc7-dvi
##   Checking ./xc7-dvi/top_colour.sv
##   Checking ./xc7-dvi/top_flag_ethiopia.sv
##   Checking ./xc7-dvi/top_flag_sweden.sv
##   Checking ./xc7-dvi/top_square.sv
```

You can learn more about this from [Verilog Lint with Verilator](https://projectf.io/posts/verilog-lint-with-verilator/).

## SystemVerilog?

These designs use a little SystemVerilog to make Verilog more pleasant. See the [Library README](../../lib/README.md#systemverilog) for details of SV features used.
