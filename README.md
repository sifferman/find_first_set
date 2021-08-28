
# Find First Set

Repository: <https://github.com/E4tHam/find_first_set>

## About

Learn about the [Find First Set Operation](https://en.wikipedia.org/wiki/Find_first_set).

This is a logarithmic complexity implementation with recursive modules witten in Verilog-2001.

This module is compatible with [FuseSoC](https://github.com/olofk/fusesoc). It's core name is `e4tham::ffs`.

## Usage

To download via `curl`:

```bash
curl -LJO https://raw.githubusercontent.com/E4tHam/find_first_set/main/rtl/ffs.v
```

To add this library via FuseSoC:

```bash
fusesoc library add e4tham_ffs https://github.com/E4tHam/find_first_set --sync-type=git
```
