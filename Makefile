APPS = kernel stdlib sasl erts
	
COMBO_PLT = $(HOME)/.handyman_combo_dialyzer_plt

.PHONY: deps test rel

all: deps compile test

compile:
	./rebar compile

deps:
	./rebar get-deps

generate:
	./rebar generate

rel: deps compile generate

relclean:
	rm -rf rel/handyman

clean: distclean
	./rebar clean

distclean:
	./rebar delete-deps

test: deps compile
	./rebar skip_deps=true eunit

docs: deps
	./rebar skip_deps=true doc

build_plt: compile
	dialyzer --build_plt --output_plt $(COMBO_PLT) --apps $(APPS) \
		deps/*/ebin

check_plt: compile
	dialyzer --check_plt --plt $(COMBO_PLT) --apps $(APPS) \
		deps/*/ebin

dialyzer: compile
	@echo
	@echo Use "'make check_plt'" to check PLT prior to using this target.
	@echo Use "'make build_plt'" to build PLT prior to using this target.
	@echo
	dialyzer --plt $(COMBO_PLT) ebin


