#!/bin/bash

pandoc  \
	$EXTRA \
	-f gfm \
	--toc \
	--standalone \
	--pdf-engine=xelatex \
	--highlight-style setup/pygments.theme \
	--top-level-division=chapter \
	--css setup/epub.css \
	-V linkcolor:blue \
	-V geometry:a4paper \
	-V geometry:margin=2cm \
	-V mainfont="DejaVu Serif" \
	-V monofont="DejaVu Sans Mono" \
	--metadata=title:"Git Inside Out" \
	--metadata=author:"Ghislain Rodrigues" \
	--metadata=lang:"en-GB" \
	-o "$1" \
	$(ls -v ./src/*.md)
