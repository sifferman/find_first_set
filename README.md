
# Find First Set

Repository: <https://github.com/E4tHam/find_first_set>

## About

Learn about the [Find First Set Operation](https://en.wikipedia.org/wiki/Find_first_set).

This is a logarithmic complexity implementation with recursive modules witten in Verilog-2001.

This module is compatible with [FuseSoC](https://github.com/olofk/fusesoc). It's core name is `e4tham::ffs`.

## Downloading

To download via `curl`:

```bash
curl -LJO https://raw.githubusercontent.com/E4tHam/find_first_set/main/rtl/ffs.v
```

To add this library via FuseSoC:

```bash
fusesoc library add e4tham_ffs https://github.com/E4tHam/find_first_set --sync-type=git
```

## Usage

The `ffs_m` module scans through an input vector `in` with width `INPUT_WIDTH` and puts the index of the first 1 in `out`.

_Extra: If `SIDE == 1'b0`, it scans from msb->lsb; If `SIDE == 1'b1`, it scans from lsb->msb._

```verilog
module ffs_m #(
    parameter INPUT_WIDTH   = 8,    // input vector width
    parameter SIDE          = 1'b0, // 0 or 1 means scanning from msb->lsb or lsb->msb
    parameter USE_X         = 1'b0  // (for debugging) invalid inputs will have {x} as output
) (
    input             [INPUT_WIDTH-1:0] in,     // input vector to scan
    output                              valid,  // whether the input has a 1
    output    [$clog2(INPUT_WIDTH)-1:0] out     // the index of the first 1
);
    ···
endmodule
```
