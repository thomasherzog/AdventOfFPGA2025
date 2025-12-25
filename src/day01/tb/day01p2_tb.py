import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

from day01_stimuli_gen import load_stimuli, gen_expected_outputs_p2


async def test_stimuli(dut, stimuli, outputs):
    dut.rst_ni.value = 0
    await Timer(1.5, unit="ns")
    dut.rst_ni.value = 1
    await RisingEdge(dut.ready_o)

    for i, (direction, amount) in enumerate(stimuli):
        dut.direction_i.value = 0 if direction == 'L' else 1
        dut.amount_i.value = amount

        await RisingEdge(dut.ready_o)
        expected_zeros = outputs[i]
        actual_zeros = dut.result_o.value.to_unsigned()

        assert actual_zeros == expected_zeros, f"At step {i}, expected zeros_accum {expected_zeros}, got {actual_zeros}"


@cocotb.test()
async def test_part2_stimuli_small(dut):
    Clock(dut.clk_i, 1, unit='ns').start()
    stimuli = load_stimuli("stim_small.txt")
    outputs = gen_expected_outputs_p2(stimuli)
    print(outputs)
    await test_stimuli(dut, stimuli, outputs)


@cocotb.test()
async def test_part2_stimuli_large(dut):
    Clock(dut.clk_i, 1, unit='ns').start()
    stimuli = load_stimuli("stim_large.txt")
    outputs = gen_expected_outputs_p2(stimuli)
    await test_stimuli(dut, stimuli, outputs)
