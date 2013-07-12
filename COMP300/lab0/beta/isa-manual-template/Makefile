all: manual.pdf


manual.ps: $(wildcard *.tex) $(wildcard lib/tex/*)
	latex manual
	latex manual
	dvips manual


%.pdf: %.ps
	ps2pdf $*.ps

clean:
	rm -f manual.dvi manual.ps manual.pdf manual.log manual.aux instruction.aux instruction-set.dvi instruction-set.log *.aux
