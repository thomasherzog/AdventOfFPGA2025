import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

from day07_stimuli_gen import load_stimuli, gen_expected_outputs_p1


async def test_stimuli(dut, stimuli, outputs):
    dut.rst_ni.value = 0
    await Timer(1.5, unit="ns")
    dut.rst_ni.value = 1
    await RisingEdge(dut.ready_o)

    for i, field_sequence in enumerate(stimuli):
        for field in field_sequence:
            dut.field_i.value = field
            dut.eol_i.value = 0
            await RisingEdge(dut.ready_o)

        dut.eol_i.value = 1
        await RisingEdge(dut.ready_o)

        expected_splits = outputs[i]
        actual_splits = dut.result_o.value.to_unsigned()

        assert actual_splits == expected_splits, f"At line {i}, expected splits {expected_splits}, got {actual_splits}"


@cocotb.test()
async def test_part1_stimuli_small(dut):
    Clock(dut.clk_i, 1, unit='ns').start()
    stimuli = load_stimuli("stim_small.txt")
    outputs = gen_expected_outputs_p1(stimuli)
    await test_stimuli(dut, stimuli, outputs)


@cocotb.test()
async def test_part1_stimuli_large(dut):
    Clock(dut.clk_i, 1, unit='ns').start()
    stimuli = load_stimuli("stim_large.txt")
    outputs = gen_expected_outputs_p1(stimuli)
    await test_stimuli(dut, stimuli, outputs)
