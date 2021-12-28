GS ?= gostatic

compile:
	$(GS) config
	touch docs/.nojekyll

w:
	mkdir -p docs
	touch docs/.nojekyll
	$(GS) -w config
