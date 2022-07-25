SHELL := /bin/bash

cfile := %%f
outfolder := PDFs
readmemd := README.md
placeholder := xyzSONGSCOUNTxyz
raws := $(filter-out $(readmemd), $(wildcard *.md))
pandoc := pandoc --pdf-engine=xelatex -H template.tex --verbose
ccreadme := sed 's/$(placeholder)/$(words $(raws))/'

default: readme

readme: $(readmemd).og
	$(ccreadme) $< > $(readmemd)

%.md.pdf: %.md
	$(pandoc) -o "$(outfolder)/$@" $<
	make readme

all: $(raws)
	@for f in $(raws); do make $${f}.pdf; done

spell: $(raws)
	rm "$(f).bak" || echo
	$(eval SELECTION := $(shell hunspell -t -u -d it_IT,en_US "$(f)" | uniq | fzf --preview-window wrap --preview="echo {} | cut -c6- | sed 's/:.*//' | xargs -If sed -n fp \"$(f)\""))
	$(eval LINE := $(shell echo "$(SELECTION)" | cut -c6- | sed 's/:.*//'))
	$(eval WORDS := $(shell echo "$(SELECTION)" | sed 's/.*: //'))
	$(eval Wi := $(shell echo "$(WORDS)" | sed 's/ -> .*//'))
	$(eval Wf := $(shell echo "$(WORDS)" | sed 's/.* -> //'))
	$(eval OLDLINE := $(shell cat "$(f)" | head -n$(LINE) | tail -n1 | xargs printf "%q " | rev | cut -c2- | rev))
	$(eval NEWLINE := $(shell echo "$(OLDLINE)" | sed 's/$(Wi)/$(Wf)/'))
	sed 's/$(OLDLINE)/$(NEWLINE)/' $(f) > $(f).bak
	mv "$(f).bak" "$(f)"
	make spell f=$(f)
