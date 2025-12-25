from pathlib import Path


def load_stimuli(filename):
    project_path = Path(__file__).resolve().parent
    source = project_path / ("stimuli/" + filename)
    with open(source, "r") as f:
        stimuli = [list(line.strip()) for line in f if line.strip()]
    return stimuli


def gen_expected_outputs_p1(stimuli):
    outputs = []
    for number in stimuli:
        left_digit = 0
        right_digit = 0
        for digit in number:
            if left_digit < right_digit:
                left_digit = right_digit
                right_digit = 0
            if int(digit) > right_digit:
                right_digit = int(digit)
        outputs.append(next(reversed(outputs), 0) +
                       10 * left_digit + right_digit)
    return outputs


def calc_joltage_p2(twelve_digits):
    joltage = 0
    for i in range(12):
        joltage += twelve_digits[i] * (10 ** i)
    return joltage


def gen_expected_outputs_p2(stimuli):
    outputs = []
    for number in stimuli:
        twelve_digits = [0] * 12
        for digit in number:
            for i in range(11, 0, -1):
                if twelve_digits[i] < twelve_digits[i-1]:
                    twelve_digits[i] = twelve_digits[i-1]
                    twelve_digits[i-1] = 0
            if int(digit) > twelve_digits[0]:
                twelve_digits[0] = int(digit)
        joltage = calc_joltage_p2(twelve_digits)
        outputs.append(next(reversed(outputs), 0) + joltage)
    return outputs
