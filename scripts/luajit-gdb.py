import gdb


class LjTraceBreakpoint(gdb.Breakpoint):
    def __init__(self, symbol, instance):
        super().__init__(symbol)
        self.__instance = instance

    def stop(self):
        self.__instance.stop(self.location)


class LjTraceInstance:
    def __init__(self):
        self.__i = 0
        self.__breakpoints = []
        for breakpoint in gdb.rbreak("^lj_BC_.*", minsyms=True):
            self.__breakpoints.append(LjTraceBreakpoint(breakpoint.location, self))
            breakpoint.delete()

    def stop(self, symbol):
        print(f"{self.__i} {symbol}")
        self.__i += 1


class LjTrace(gdb.Command):
    def __init__(self):
        super().__init__("lj-trace", gdb.COMMAND_RUNNING)

    def invoke(self, argument, from_tty):
        LjTraceInstance()
        gdb.execute("continue")

    def stop(*args, **kwargs):
        print((args, kwargs))


LjTrace()
