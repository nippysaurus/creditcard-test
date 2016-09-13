DEPS = main.beam

%.beam: %.erl
	erlc $<

build: $(DEPS)
	

run: build
	erl -noshell -s main hello_world -s init stop

run_test: build
	erl -noshell -s main test -s init stop

clean:
	rm -f *.beam
