#!/bin/bash

pandoc  \
	-f gfm \
	--toc \
	--standalone \
    --pdf-engine=xelatex \
	--include-in-header setup/chapter_break.tex \
	--include-in-header setup/inline_code.tex \
	--highlight-style setup/pygments.theme \
	--top-level-division=chapter \
	--css setup/epub.css \
	--metadata=title:"Git Inside Out" \
	--metadata=author:"Ghislain Rodrigues" \
	--metadata=lang:"en-GB" \
	-o "$1" \
	./00_index.md ./01_repository.md ./02_commits.md ./03_branches.md ./04_reflog.md
