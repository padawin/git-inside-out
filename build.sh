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
	$(ls -v ./src/*.md)
