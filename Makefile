pdf:
	mkdir -p out
	./build.sh out/git-book.pdf

html:
	mkdir -p out
	./build.sh out/index.html

epub:
	mkdir -p out
	./build.sh out/git-book.epub
