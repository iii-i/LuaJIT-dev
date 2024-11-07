.PHONY: all
all:
	exit 1

.PHONY: bear
bear:
	cd LuaJIT && \
		$(MAKE) clean && \
		bear --output $(PWD)/compile_commands.json -- $(MAKE) CCDEBUG=-g CCOPT=-O0 XCFLAGS="-DLUA_USE_ASSERT -DLUAJIT_USE_VALGRIND"
