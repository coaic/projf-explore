# FPGA Graphics - iCE40 (iCEBreaker)

Targets the iCEBreaker board (Lattice UP5K, sg48 package) via the open-source iCE40 toolchain.

## Toolchain

Uses Homebrew-installed tools: `yosys`, `nextpnr-ice40`, `icestorm` (provides `icetime`, `icepack`).

### Known issue: icetime chipdb path (Homebrew)

The Homebrew `icestorm` 1.1 binary for `icetime` is compiled with a hardcoded data path of
`share/icebox/chipdb-`, but the Homebrew formula installs chipdb files under `share/icestorm/chipdb/`.
This causes the error:

```
// Reading 5k chipdb file..
Can't find chipdb file for device 5k
```

**Fix** — create a symlink so `icetime` finds the files where it expects them:

```bash
ln -s /opt/homebrew/Cellar/icestorm/1.1/share/icestorm/chipdb \
      /opt/homebrew/Cellar/icestorm/1.1/share/icebox
```

If Homebrew upgrades `icestorm` to a new version, update the path accordingly (e.g. `1.2` instead of `1.1`).

This is a Homebrew packaging bug; the oss-cad-suite distribution does not have this issue.

## Build

```bash
make square          # synthesise, place-and-route, timing report, pack bitstream
make all             # build all targets: square, flag_ethiopia, flag_sweden, colour
make clean
```
