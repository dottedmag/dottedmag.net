GS ?= gostatic

compile:
	rm -rf docs
	$(GS) config
	mkdir -p docs/.well-known/matrix
	echo '{"m.server":"rooibos.dottedmag.net:8448"}' > docs/.well-known/matrix/server

w:
	mkdir -p docs
	$(GS) -w config

deploy: compile
	rsync -az --delete docs/ rooibos:/srv/www/dottedmag.net/htdocs/
