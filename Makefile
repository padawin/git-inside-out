all: pdf html epub
pdf:
	mkdir -p out
	./build.sh out/git-book.pdf

html:
	mkdir -p out/web
	cp -r images out/web
	./build.sh out/web/index.html

epub:
	mkdir -p out
	./build.sh out/git-book.epub
