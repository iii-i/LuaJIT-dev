export CCDEBUG=-g
export CCOPT=-O0
export XCFLAGS="-DLUA_USE_ASSERT -DLUAJIT_USE_VALGRIND"

.PHONY: all
all:
	cd LuaJIT && $(MAKE)

.PHONY: bear
bear:
	cd LuaJIT && \
		$(MAKE) clean && \
		bear --output $(PWD)/.compile_commands.json -- $(MAKE) && \
		mv $(PWD)/.compile_commands.json $(PWD)/compile_commands.json

.PHONY: qtcreator
qtcreator: bear
	qtcreator compile_commands.json &
