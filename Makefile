cfile := %%f
outfolder := PDFs
readmemd := README.md
placeholder := xyzSONGSCOUNTxyz
raws := $(wildcard *.md)
pandoc := pandoc --pdf-engine=xelatex -H template.tex --verbose
ccreadme := sed 's/$(placeholder)/$(shell expr $(words $(raws)) - 1)/'

default: missing

readme: $(readmemd).og
	$(ccreadme) $< > $(readmemd)

%.md.pdf: %.md
	$(pandoc) -o "$(outfolder)/$@" $<
	make readme

missing: $(raws)
	for $(cfile) in ($(raws)) do if not exist "$(outfolder)/$(cfile).pdf" (make $(cfile).pdf)

all: $(raws)
	for $(cfile) in ($(raws)) do make $(cfile).pdf