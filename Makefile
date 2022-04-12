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
