MFLAGS=CCDEBUG=-g CCOPT=-O0 XCFLAGS="-DLUA_USE_ASSERT -DLUAJIT_USE_VALGRIND"

.PHONY: all
all:
	cd LuaJIT && $(MAKE) $(MFLAGS)

.PHONY: install
install:
	cd LuaJIT && $(MAKE) $(MFLAGS) install PREFIX=$(PWD)/dist

.PHONY: test
test: install
	cd luajit2-test-suite && \
		./run-tests \
			$(PWD)/dist \
			$(PWD)/dist/bin/luajit \
			$(CROSS)gcc \
			$(CROSS)g++

.PHONY: bear
bear:
	cd LuaJIT && \
		$(MAKE) clean && \
		bear --output $(PWD)/.compile_commands.json -- \
			$(MAKE) $(MFLAGS) && \
		mv $(PWD)/.compile_commands.json $(PWD)/compile_commands.json

.PHONY: qtcreator
qtcreator: bear
	qtcreator compile_commands.json &
