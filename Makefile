cfile := %%f
outfolder := PDFs
raws := $(wildcard *.md)
compile := pandoc $(cfile) -o "$(outfolder)/$(cfile).pdf" --pdf-engine=xelatex -H template.tex --verbose

default: missing

missing: $(raws)
	for $(cfile) in ($(raws)) do if not exist "$(outfolder)/$(cfile).pdf" ($(compile))

all: $(raws)
	for $(cfile) in ($(raws)) do $(compile)