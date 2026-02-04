MFLAGS=CCDEBUG=-g CCOPT=-O0 XCFLAGS="-DLUA_USE_ASSERT -DLUAJIT_USE_VALGRIND"
# https://github.com/LuaJIT/LuaJIT/pull/1302
SKIP_TESTS=test/sysdep/ffi_include_gtk.lua
SKIP_TESTS+=test/sysdep/ffi_include_std.lua
# module 'table.clone' not found
SKIP_TESTS+=test/misc/hstore_elimination.lua
TESTS=$(shell cd luajit2-test-suite && git ls-files test/*.lua | grep -v $(foreach t,$(SKIP_TESTS),-e $(t)))

.PHONY: all
all:
	cd LuaJIT && $(MAKE) $(MFLAGS)
	cd luajit2 && $(MAKE) $(MFLAGS)

.PHONY: clean
clean:
	cd LuaJIT && git clean -dfx
	cd luajit2 && git clean -dfx
	cd luajit2-test-suite && git clean -dfx

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
			$(CROSS)g++ \
			$(TESTS)

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
