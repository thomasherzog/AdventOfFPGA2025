# Advent of FPGA 2025

This repository contains my submission for the Jane Street Advent of FPGA Challenge. It features SystemVerilog solutions for Advent of Code problems, complete with cocotb testbenches and architectural write-ups.

## Requirements
* Python
* Verilator

## Dependencies

```bash
pip install -r requirements.txt
```

## Challenges

* [Day 1: Secret Entrance](https://github.com/thomasherzog/AdventOfFPGA2025/tree/master/src/day01)
* [Day 3: Lobby](https://github.com/thomasherzog/AdventOfFPGA2025/tree/master/src/day03)
* [Day 7: Laboratories](https://github.com/thomasherzog/AdventOfFPGA2025/tree/master/src/day07)

## Structure

```
.
├── README.md              
└── src
    ├── day01
    │   ├── rtl/            # SystemVerilog RTL
    │   ├── tb/             # cocotb Testbench
    │   └── README.md       # Explanation
    ├── day03
    │   └── ...
```
