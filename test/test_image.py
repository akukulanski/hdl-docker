from nmigen import *

class Counter(Elaboratable):
    def __init__(self, width):
        self.v = Signal(width, reset=2**width-1)
        self.o = Signal()

    def elaborate(self, platform):
        m = Module()
        m.d.sync += self.v.eq(self.v + 1)
        m.d.comb += self.o.eq(self.v[-1])
        return m


def test_verilog():
    from nmigen.hdl.ir import Fragment
    from nmigen.back import verilog
    
    ctr = Counter(width=16)
    fragment = Fragment.get(ctr, None)
    output = verilog.convert(fragment, name='example', ports=[ctr.o])

    with open('./example.v', 'w') as f:
        f.write(output)


def test_nmigen_cocotb():
    from nmigen_cocotb import run
    
    ctr = Counter(width=16)
    run(ctr, 'tb_counter', ports=[ctr.o], vcd_file='./test_counter.vcd')
