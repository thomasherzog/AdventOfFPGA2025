# Day 7: Laboratories

Simulation of the path of a high-energy particle beam ("Tachyon") traversing a 2D grid of devices. The beam originates from the top row and moves downward.

[Advent Of Code Problem](https://adventofcode.com/2025/day/7)

## Part 1

The module treats the problem as a stream-processing task where the "state" of the system is the set of columns currently containing an active beam. It uses two 150-bit vectors, current_state (row N) and next_state (row N+1), to compute beam propagation and splitting logic in real-time as the map data streams in.

### Data Path

* Input Interface: Reads the map serially, one cell (field_i) at a time, delineated by eol_i.

* Registers:

    * current_state_q: A 150-bit bitmap where bit k is High if a beam exists in column k of the previous row.

    * next_state_q: Accumulates the beam positions for the current row being constructed.

    * beam_splits_q: 16-bit counter tracking the total number of split events.

    * board_width_q: Captures the map width during the first row processing.

* Logic (Cellular Update):

    * Initialization (Phase 1): During the first line, the FSM constructs the initial current_state bitmap and counts the board_width.

    * Propagation (Phase 2): For every subsequent cell, the logic checks if a beam exists directly "above" the current pixel (checking current_state_q[index]).

        * Pass-through: If a beam is above and the current field is 0 (Empty), the beam continues straight down (sets bit i in next_state).

        * Split Event: If a beam is above and the current field is 1 (Splitter), the beam splits. The logic sets bits i−1 and i+1 in next_state (Diagonal scatter) and increments beam_splits_q.

### Run Testbench

```
python ./tb/day07p1_runner.py
```

* [RTL](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day07/rtl/day07p1_top.sv)
* [Testbench](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day07/tb/day07p1_tb.py)

