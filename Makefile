MFLAGS=CCDEBUG=-g CCOPT=-O0 XCFLAGS="-DLUA_USE_ASSERT -DLUAJIT_USE_VALGRIND"

.PHONY: all
all:
	cd LuaJIT && $(MAKE) $(MFLAGS)
	cd luajit2 && $(MAKE) $(MFLAGS)

.PHONY: clean
clean:
	cd LuaJIT && $(MAKE) $(MFLAGS) clean
	cd luajit2 && $(MAKE) $(MFLAGS) clean

.PHONY: install
install:
	cd LuaJIT && $(MAKE) $(MFLAGS) install PREFIX=$(PWD)/dist-LuaJIT
	cd LuaJIT && $(MAKE) $(MFLAGS) install PREFIX=$(PWD)/dist-luajit2

.PHONY: __test
__test:
	cd luajit2-test-suite && \
		./run-tests \
			$(PWD)/dist-$(FLAVOR) \
			$(PWD)/dist-$(FLAVOR)/bin/luajit \
			$(CROSS)gcc \
			$(CROSS)g++


.PHONY: test
test: install
	$(MAKE) __test FLAVOR=LuaJIT
	$(MAKE) __test FLAVOR=luajit2

.PHONY: bear
bear:
	$(MAKE) clean
	bear --output .compile_commands.json -- $(MAKE)
	mv .compile_commands.json compile_commands.json

.PHONY: qtcreator
qtcreator: bear
	qtcreator compile_commands.json &

.PHONY: gdb
gdb:
	gdb-multiarch \
		-ex 'set pagination off' \
		-ex 'source scripts/luajit-gdb.py' \
		-ex 'target remote :1234' \
		LuaJIT/src/luajit
