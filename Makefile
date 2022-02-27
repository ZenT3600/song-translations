cfile := %%f
outfolder := PDFs
raws := $(wildcard *.md)
pandoc := pandoc --pdf-engine=xelatex -H template.tex --verbose

default: missing

%.md.pdf: %.md
	$(pandoc) -o "$(outfolder)/$@" $<

missing: $(raws)
	for $(cfile) in ($(raws)) do if not exist "$(outfolder)/$(cfile).pdf" (make $(cfile).pdf)

all: $(raws)
	for $(cfile) in ($(raws)) do make $(cfile)