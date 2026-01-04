# Day 3: Lobby

Selection process in a list of integers such that their original relative order is preserved and their combined integer value is maximized. The input is read in sequentially using a primitive valid-ready handshake. 

[Advent Of Code Problem](https://adventofcode.com/2025/day/3)

## Part 1

The solution uses a FSM to process an incoming stream of 4-bit digits. It calculates the total joltage by accumulating the largest 2-digit value found in each line of input.

### Data Path

* Input Interface: Accepts 4-bit digits (digit_i) and an End-of-Line flag (eol_i).

* Registers:

    * left_digit_q / right_digit_q: Stores the optimal Tens and Ones digits for the current line.

    * joltage_q: A 64-bit accumulator that sums the results of all processed lines.

* Comparator Logic: In the Process state, the design greedily updates the stored digits. If the current right_digit exceeds left_digit, it shifts right to left. Otherwise, it updates right_digit if the new input is larger.

### Run Testbench

```
python ./tb/day03p1_runner.py
```

* [RTL](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day03/rtl/day03p1_top.sv)
* [Testbench](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day03/tb/day03p1_tb.py)


## Part 2

The design is similar to Part 1 but processes each incoming digit over multiple clock cycles to maintain a sorted buffer of the "Top 12" values encountered.

### Data Path

* Input Interface: Accepts 4-bit digits (digit_i) and an End-of-Line flag (eol_i) identical to Part 1.

* Registers:

    * twelve_digits_q: A 48-bit register array (12 × 4-bit) that stores the current best 12 digits.

    * index_q: A 4-bit counter used to iterate through the array for both sorting and summation.

    * power_q: Stores the current power of 10 during the summation phase.

    * joltage_q: A 64-bit accumulator for the final result.

* Comparator Logic: Instead of a single-cycle swap, the logic performs a sequential "bubble" operation. In the Process state, it iterates through the array, comparing twelve_digits[i] against twelve_digits[i-1]. It shifts values to ensure the array remains sorted, effectively pushing the smallest digit to index 0 where it can be overwritten if the new incoming digit is larger.

### Run Testbench

```
python ./tb/day03p2_runner.py
```

* [RTL](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day03/rtl/day03p2_top.sv)
* [Testbench](https://github.com/thomasherzog/AdventOfFPGA2025/blob/master/src/day03/tb/day03p2_tb.py)
