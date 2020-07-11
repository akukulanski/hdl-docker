import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotb.regression import TestFactory as TF

async def reset(dut):
    dut.rst <= 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst <= 0


@cocotb.test()
def check_data(dut):
    cocotb.fork(Clock(dut.clk, 10, 'ns').start())
    yield reset(dut)
    yield RisingEdge(dut.clk)
    yield RisingEdge(dut.clk)
    for i in range(min(4, 2**len(dut.v))):
        assert dut.v.value.integer == i, f'{dut.v.value.integer} != {i}'
        yield RisingEdge(dut.clk)