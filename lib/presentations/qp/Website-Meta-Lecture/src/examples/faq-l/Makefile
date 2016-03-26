DEPS = api.wml questions.wml


all: index.html answers.html

index.html: index.html.wml $(DEPS)
	wml --passoption=2,-X3074 $< > $@

answers.html: answers.html.wml $(DEPS)
	wml --passoption=2,-X3074 $< > $@

