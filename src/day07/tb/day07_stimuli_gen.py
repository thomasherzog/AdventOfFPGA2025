from pathlib import Path


def load_stimuli(filename):
    project_path = Path(__file__).resolve().parent
    source = project_path / ("stimuli/" + filename)
    stimuli = []
    with open(source, "r") as f:
        for line in f:
            line_stim = []
            line = line.strip()
            for char in line:
                if char == '.':
                    line_stim.append(0)
                elif char == '^' or char == 'S':
                    line_stim.append(1)
            stimuli.append(line_stim)
    return stimuli


def gen_expected_outputs_p1(stimuli):
    outputs = [0]
    board_width = len(stimuli[0])
    first_line = stimuli[0]
    binary_string = "".join(str(bit) for bit in first_line)

    current_state = int(binary_string, 2)
    next_state = 0

    beam_splits = 0

    for line in stimuli[1:]:
        i = 0
        for char in line:
            current_bit_mask = 0b1 << i
            current_state_bit = (current_state & current_bit_mask) >> i
            current_field_bit = char
            if current_state_bit & current_field_bit == 0b1:
                if i == 0:
                    next_state |= 0b1
                elif i == (board_width - 1):
                    next_state |= 0b1 << (i - 1)
                else:
                    next_state |= 0b101 << (i - 1)
                beam_splits += 1
            elif current_state_bit == 0b1:
                next_state |= 0b1 << i
            i += 1
        current_state = next_state
        next_state = 0
        outputs.append(beam_splits)
    return outputs
