NIM ?= nim
NIMFLAGS ?=
LIB_SOURCES := $(wildcard src/*.nim src/drpge/*.nim)
EXAMPLE_DEBUG_FLAGS := --debugger:native --lineDir:on --stackTrace:on --lineTrace:on \
	--opt:none '--gcc.options.debug:-g3 -O0'

.PHONY: all run test

all: build/drpge-example

run: build/drpge-example
	./build/drpge-example

test: build/test-drpge
	./build/test-drpge

build:
	mkdir -p $@

build/drpge-example: examples/demo.nim $(LIB_SOURCES) nim.cfg Makefile | build
	$(NIM) c $(NIMFLAGS) $(EXAMPLE_DEBUG_FLAGS) --nimcache:build/nimcache/example --out:$@ $<

build/test-drpge: tests/test_drpge.nim $(LIB_SOURCES) nim.cfg Makefile | build
	$(NIM) c $(NIMFLAGS) --nimcache:build/nimcache/test --out:$@ $<
