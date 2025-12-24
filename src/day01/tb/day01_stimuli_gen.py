from pathlib import Path


def load_stimuli(filename):
    project_path = Path(__file__).resolve().parent
    source = project_path / ("stimuli/" + filename)
    with open(source, "r") as f:
        stimuli = [(line.strip()[0], int(line.strip()[1:]))
                   for line in f if line.strip()]
    return stimuli


def gen_expected_outputs_p1(stimuli):
    outputs = []
    dial = 50
    zeros_accum = 0
    for direction, amount in stimuli:
        if direction == 'L':
            dial = (dial - amount) % 100
        elif direction == 'R':
            dial = (dial + amount) % 100
        if dial == 0:
            zeros_accum += 1
        outputs.append(zeros_accum)
    return outputs
