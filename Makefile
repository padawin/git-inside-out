all: pdf html epub
pdf:
	mkdir -p out
	EXTRA="--include-in-header setup/chapter_break.tex --include-in-header setup/inline_code.tex" ./build.sh out/git-book.pdf

html:
	mkdir -p out/web
	cp -r images out/web
	./build.sh out/web/index.html

epub:
	mkdir -p out
	EXTRA="--include-in-header setup/chapter_break.tex --include-in-header setup/inline_code.tex" ./build.sh out/git-book.epub
