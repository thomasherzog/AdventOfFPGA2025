# Day 1: Secret Entrance

A simulation of a dial with numbers 0 through 99 arranged in a circle. Starting at position 50, the module processes a list of rotational instructions. The input is read in sequentially using a valid-ready handshake. The logic normalizes large rotation values by iteratively subtracting 100, then calculates the new dial position using modulo-100 arithmetic to handle circular wrap-around. 

[Advent Of Code Problem](https://adventofcode.com/2025/day/1)

## Part 1

### Run Testbench

```
python ./tb/day01p1_runner.py
```

* [RTL](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day01/rtl/day01p1_top.sv)
* [Testbench](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day01/tb/day01p1_tb.py)

## Part 2

### Run Testbench

```
python ./tb/day01p2_runner.py
```

* [RTL](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day01/rtl/day01p2_top.sv)
* [Testbench](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day01/tb/day01p2_tb.py)