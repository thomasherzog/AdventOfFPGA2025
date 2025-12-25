from pathlib import Path
from cocotb_tools.runner import get_runner


def run_testbench():
    project_path = Path(__file__).resolve().parent.parent
    sources = [project_path / "rtl/day03p2_top.sv"]
    runner = get_runner("verilator")
    runner.build(
        sources=sources,
        hdl_toplevel="day03p2_top",
        waves=True,
        build_args=["--trace", "--trace-structs", "--trace-fst"],
    )
    runner.test(
        hdl_toplevel="day03p2_top",
        test_module="day03p2_tb,",
        test_args=["--trace", "--trace-structs", "--trace-fst"]
    )


if __name__ == "__main__":
    run_testbench()
