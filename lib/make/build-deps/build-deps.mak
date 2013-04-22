EXES_LIST = bin/needed-executables.txt

MODULES_LIST = bin/required-modules.yml

BIN = ./bin/gen-build-deps

STAMP = lib/make/build-deps/build-deps.stamp

all: $(STAMP)

$(STAMP): $(BIN) $(EXES_LIST) $(MODULES_LIST)
	$(BIN) -o $@ --exes-conf $(EXES_LIST) --modules-conf $(MODULES_LIST)

clean:
	rm -f $(STAMP)
