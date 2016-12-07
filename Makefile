
OCAMLBUILD=ocamlbuild -use-ocamlfind -tag debug
TARGETS=src/smbc.native src/smbc.byte
BINDIR ?= /usr/bin/

all: build

build:
	$(OCAMLBUILD) $(TARGETS)

clean:
	$(OCAMLBUILD) -clean

install: build
	cp smbc.native $(BINDIR)/smbc

test: build
	frogtest run -c test.toml --meta `git rev-parse HEAD`

watch:
	while find src/ -print0 | xargs -0 inotifywait -e delete_self -e modify ; do \
		echo "============ at `date` ==========" ; \
		sleep 0.1; \
		make all; \
	done

PERF_CONF = test_perf.toml
perf_compare: build $(PERF_CONF)
	frogtest run -c $(PERF_CONF) # --no-caching
	frogtest plot -c $(PERF_CONF) -o perf.pdf
	frogtest csv -o perf.csv

benchs: build
	frogtest run -c benchmarks/smbc.toml --meta `git rev-parse HEAD`

hbmc_benchs: build
	frogtest run -c benchs_hbmc/conf.toml

.PHONY: watch benchs clean build test
