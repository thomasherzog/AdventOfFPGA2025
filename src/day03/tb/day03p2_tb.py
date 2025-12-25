import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

from day03_stimuli_gen import load_stimuli, gen_expected_outputs_p2


async def test_stimuli(dut, stimuli, outputs):
    dut.rst_ni.value = 0
    await Timer(1.5, unit="ns")
    dut.rst_ni.value = 1
    await RisingEdge(dut.ready_o)

    for i, digit_sequence in enumerate(stimuli):
        for digit in digit_sequence:
            dut.digit_i.value = int(digit)
            dut.eol_i.value = 0
            await RisingEdge(dut.ready_o)

        dut.eol_i.value = 1
        await RisingEdge(dut.ready_o)

        expected_joltage = outputs[i]
        actual_joltage = dut.result_o.value.to_unsigned()

        assert actual_joltage == expected_joltage, f"At step {i}, expected joltage {expected_joltage}, got {actual_joltage}"


@cocotb.test()
async def test_part1_stimuli_small(dut):
    Clock(dut.clk_i, 1, unit='ns').start()
    stimuli = load_stimuli("stim_small.txt")
    outputs = gen_expected_outputs_p2(stimuli)
    await test_stimuli(dut, stimuli, outputs)


@cocotb.test()
async def test_part1_stimuli_large(dut):
    Clock(dut.clk_i, 1, unit='ns').start()
    stimuli = load_stimuli("stim_large.txt")
    outputs = gen_expected_outputs_p2(stimuli)
    await test_stimuli(dut, stimuli, outputs)
