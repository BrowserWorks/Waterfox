### Makefile for Emacs refcards

## Copyright (C) 1993-1994, 2001-2014 Free Software Foundation, Inc.

## This file is part of GNU Emacs.
#
## GNU Emacs is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## GNU Emacs is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

### Commentary:

## See README for details.

PDF_ENGLISH = \
	calccard.pdf \
	dired-ref.pdf \
	gnus-booklet.pdf \
	gnus-refcard.pdf \
	orgcard.pdf \
	refcard.pdf \
	survival.pdf \
	vipcard.pdf \
	viperCard.pdf

PDF_CZECH = \
	cs-dired-ref.pdf \
	cs-refcard.pdf \
	cs-survival.pdf

PDF_FRENCH = \
	fr-dired-ref.pdf \
	fr-refcard.pdf \
	fr-survival.pdf \

PDF_GERMAN = de-refcard.pdf

PDF_POLISH = pl-refcard.pdf

PDF_PORTUGUESE = pt-br-refcard.pdf

PDF_RUSSIAN = ru-refcard.pdf

PDF_SLOVAKIAN = \
	sk-dired-ref.pdf \
	sk-refcard.pdf \
	sk-survival.pdf

PDF_TARGETS = $(PDF_ENGLISH) $(PDF_CZECH) $(PDF_FRENCH) $(PDF_GERMAN) \
	$(PDF_POLISH) $(PDF_PORTUGUESE) $(PDF_RUSSIAN) $(PDF_SLOVAKIAN)

PS_ENGLISH = $(PDF_ENGLISH:.pdf=.ps)
PS_CZECH = $(PDF_CZECH:.pdf=.ps)
PS_FRENCH = $(PDF_FRENCH:.pdf=.ps)
PS_GERMAN = $(PDF_GERMAN:.pdf=.ps)
PS_POLISH = $(PDF_POLISH:.pdf=.ps)
PS_PORTUGUESE = $(PDF_PORTUGUESE:.pdf=.ps)
PS_RUSSIAN = $(PDF_RUSSIAN:.pdf=.ps)
PS_SLOVAKIAN = $(PDF_SLOVAKIAN:.pdf=.ps)

PS_TARGETS = $(PDF_TARGETS:.pdf=.ps)


## For emacsver.tex.
ENVADD = TEXINPUTS=".:$(TEXINPUTS)"


.PHONY: all pdf ps

all: pdf
pdf: $(PDF_TARGETS)
ps: $(PS_TARGETS)


.PHONY: english czech french german polish portuguese russian slovakian
english: $(PDF_ENGLISH)
czech: $(PDF_CZECH)
french: $(PDF_FRENCH)
german: $(PDF_GERMAN)
polish: $(PDF_POLISH)
portuguese: $(PDF_PORTUGUESE)
russian: $(PDF_RUSSIAN)
slovakian: $(PDF_SLOVAKIAN)

.PHONY: english-ps czech-ps french-ps german-ps polish-ps portuguese-ps russian-ps slovakian-ps
english-ps: $(PS_ENGLISH)
czech-ps: $(PS_CZECH)
french-ps: $(PS_FRENCH)
german-ps: $(PS_GERMAN)
polish-ps: $(PS_POLISH)
portuguese-ps: $(PS_PORTUGUESE)
russian-ps: $(PS_RUSSIAN)
slovakian-ps: $(PS_SLOVAKIAN)


## Default for file that do not use a different paper size.
.SUFFIXES: .ps .dvi
.dvi.ps:
	dvips -t letter -o $@ $<


make_cs=if pdfcsplain --version > /dev/null 2> /dev/null; then \
	  $(ENVADD) pdfcsplain $$input; \
	else \
	  $(ENVADD) csplain "\pdfoutput=1\input $$input"; \
	fi

## For pdf output, the page layouts (a4/letter) are written directly
## in the .tex files.

## For PostScript output, note that some of the tex files (refcard,
## de-refcard, fr-refcard, pt-br-refcard) have settings for letter or
## a4 paper.  The Following are the default paper sizes (letter for English,
## A4 for translations).
## FIXME orgcard.ps does not fit on letter (see orgcard.tex).

## A4, landscape: de-refcard, fr-refcard, pt-br-refcard orgcard
## A4, portrait: cs-*, fr-dired-ref, sk-*, pl-refcard, ru-refcard
## Letter, landscape: calccard, refcard
## Letter, portrait (suffix rule): dired-ref, gnus-*, survival, vip*

calccard_deps = calccard.tex emacsver.tex pdflayout.sty
calccard.pdf: $(calccard_deps)
	$(ENVADD) pdftex calccard.tex
calccard.dvi: $(calccard_deps)
	$(ENVADD) tex calccard.tex
calccard.ps: calccard.dvi
	dvips -t letter -t landscape -o $@ calccard.dvi

cs_dired_ref_deps = cs-dired-ref.tex emacsver.tex pdflayout.sty
cs-dired-ref.pdf: $(cs_dired_ref_deps)
	input=cs-dired-ref.tex; $(make_cs)
cs-dired-ref.dvi: $(cs_dired_ref_deps)
	$(ENVADD) csplain cs-dired-ref.tex
cs-dired-ref.ps: cs-dired-ref.dvi
	dvips -t a4 -o $@ cs-dired-ref.dvi

cs_refcard_deps = cs-refcard.tex emacsver.tex pdflayout.sty
cs-refcard.pdf: $(cs_refcard_deps)
	input=cs-refcard.tex; $(make_cs)
cs-refcard.dvi: $(cs_refcard_deps)
	$(ENVADD) csplain cs-refcard.tex
cs-refcard.ps: cs-refcard.dvi
	dvips -t a4 -o $@ cs-refcard.dvi

cs_survival_deps = cs-survival.tex emacsver.tex pdflayout.sty
cs-survival.pdf: $(cs_survival_deps)
	input=cs-survival.tex; $(make_cs)
cs-survival.dvi: $(cs_survival_deps)
	$(ENVADD) csplain cs-survival.tex
cs-survival.ps: cs-survival.dvi
	dvips -t a4 -o $@ cs-survival.dvi

de_refcard_deps = de-refcard.tex emacsver.tex pdflayout.sty
de-refcard.pdf: $(de_refcard_deps)
	$(ENVADD) pdftex de-refcard.tex
de-refcard.dvi: $(de_refcard_deps)
	$(ENVADD) tex de-refcard.tex
de-refcard.ps: de-refcard.dvi
	dvips -t a4 -t landscape -o $@ de-refcard.dvi

dired_ref_deps = dired-ref.tex emacsver.tex pdflayout.sty
dired-ref.pdf: $(dired_ref_deps)
	$(ENVADD) pdftex dired-ref.tex
dired-ref.dvi: $(dired_ref_deps)
	$(ENVADD) tex dired-ref.tex

fr_dired_ref_deps = fr-dired-ref.tex emacsver.tex pdflayout.sty
fr-dired-ref.pdf: $(fr_dired_ref_deps)
	$(ENVADD) pdftex fr-dired-ref.tex
fr-dired-ref.dvi: $(fr_dired_ref_deps)
	$(ENVADD) tex fr-dired-ref.tex
fr-dired-ref.ps: fr-dired-ref.dvi
	dvips -t a4 -o $@ fr-dired-ref.dvi

fr_refcard_deps = fr-refcard.tex emacsver.tex pdflayout.sty
fr-refcard.pdf: $(fr_refcard_deps)
	$(ENVADD) pdftex fr-refcard.tex
fr-refcard.dvi: $(fr_refcard_deps)
	$(ENVADD) tex fr-refcard.tex
fr-refcard.ps: fr-refcard.dvi
	dvips -t a4 -t landscape -o $@ fr-refcard.dvi

fr_survival_deps = fr-survival.tex emacsver.tex pdflayout.sty
fr-survival.pdf: $(fr_survival_deps)
	$(ENVADD) pdftex fr-survival.tex
fr-survival.dvi: $(fr_survival_deps)
	$(ENVADD) tex fr-survival.tex
fr-survival.ps: fr-survival.dvi
	dvips -t a4 -o $@ fr-survival.dvi

## No dependency on emacsver.tex, pdflayout.sty; no need for ENVADD.
gnus_booklet_deps = gnus-refcard.tex gnus-logo.pdf
gnus-booklet.pdf: $(gnus_booklet_deps)
	pdflatex -jobname=gnus-booklet '\def\booklettrue{}\def\letterpapertrue{}\input{gnus-refcard}'
gnus-booklet.dvi: gnus-refcard.tex gnus-logo.eps
	latex '\def\booklettrue{}\def\letterpapertrue{}\input{gnus-refcard}'
	mv gnus-refcard.dvi $@

###gnus-logo.pdf: gnus-logo.eps
###	ps2pdf gnus-logo.eps

## No dependency on emacsver.tex, pdflayout.sty; no need for ENVADD.
gnus_refcard_deps = gnus-refcard.tex gnus-logo.pdf
gnus-refcard.pdf: $(gnus_refcard_deps)
	pdflatex gnus-refcard.tex
gnus-refcard.dvi: $(gnus_refcard_deps)
	latex gnus-refcard.tex

orgcard_deps = orgcard.tex emacsver.tex pdflayout.sty
orgcard.pdf: $(orgcard_deps)
	$(ENVADD) pdftex orgcard.tex
orgcard.dvi: $(orgcard_deps)
	$(ENVADD) tex orgcard.tex
orgcard.ps: orgcard.dvi
	dvips -t a4 -t landscape -o $@ orgcard.dvi

pl_refcard_deps = pl-refcard.tex emacsver.tex pdflayout.sty
## Some versions of pdfmex seem to create dvi by default, hence output-format.
pl-refcard.pdf: $(pl_refcard_deps)
	if ! kpsewhich -format=fmt mex > /dev/null && \
	  ! pdfmex --version > /dev/null 2> /dev/null; then \
	  echo "No mex format found."; false; \
	fi
	$(ENVADD) pdftex -output-format=pdf pl-refcard.tex
pl-refcard.dvi: $(pl_refcard_deps)
	if ! kpsewhich -format=fmt mex > /dev/null; then \
	  echo "No mex format found."; false; \
	fi
	$(ENVADD) tex pl-refcard.tex
pl-refcard.ps: pl-refcard.dvi
	dvips -t a4 -o $@ pl-refcard.dvi

pt_br_refcard_deps = pt-br-refcard.tex emacsver.tex pdflayout.sty
pt-br-refcard.pdf: $(pt_br_refcard_deps)
	$(ENVADD) pdftex pt-br-refcard.tex
pt-br-refcard.dvi: $(pt_br_refcard_deps)
	$(ENVADD) tex pt-br-refcard.tex
pt-br-refcard.ps: pt-br-refcard.dvi
	dvips -t a4 -t landscape -o $@ pt-br-refcard.dvi

refcard_deps = refcard.tex emacsver.tex pdflayout.sty
refcard.pdf: $(refcard_deps)
	$(ENVADD) pdftex refcard.tex
refcard.dvi: $(refcard_deps)
	$(ENVADD) tex refcard.tex
refcard.ps: refcard.dvi
	dvips -t letter -t landscape -o $@ refcard.dvi

## No dependency on emacsver.tex, pdflayout.sty; no need for ENVADD.
ru_refcard_deps = ru-refcard.tex
ru-refcard.pdf: $(ru_refcard_deps)
	pdflatex ru-refcard.tex
ru-refcard.dvi: $(ru_refcard_deps)
	latex ru-refcard.tex
ru-refcard.ps: ru-refcard.dvi
	dvips -t a4 -o $@ ru-refcard.dvi

sk_dired_ref_deps = sk-dired-ref.tex emacsver.tex pdflayout.sty
sk-dired-ref.pdf: $(sk_dired_ref_deps)
	input=sk-dired-ref.tex; $(make_cs)
sk-dired-ref.dvi: $(sk_dired_ref_deps)
	$(ENVADD) csplain sk-dired-ref.tex
sk-dired-ref.ps: sk-dired-ref.dvi
	dvips -t a4 -o $@ sk-dired-ref.dvi

sk_refcard_deps = sk-refcard.tex emacsver.tex pdflayout.sty
sk-refcard.pdf: $(sk_refcard_deps)
	input=sk-refcard.tex; $(make_cs)
sk-refcard.dvi: $(sk_refcard_deps)
	$(ENVADD) csplain sk-refcard.tex
sk-refcard.ps: sk-refcard.dvi
	dvips -t a4 -o $@ sk-refcard.dvi

sk_survival_deps = sk-survival.tex emacsver.tex pdflayout.sty
sk-survival.pdf: $(sk_survival_deps)
	input=sk-survival.tex; $(make_cs)
sk-survival.dvi: $(sk_survival_deps)
	$(ENVADD) csplain sk-survival.tex
sk-survival.ps: sk-survival.dvi
	dvips -t a4 -o $@ sk-survival.dvi

survival_deps = survival.tex emacsver.tex pdflayout.sty
survival.pdf: $(survival_deps)
	$(ENVADD) pdftex survival.tex
survival.dvi: $(survival_deps)
	$(ENVADD) tex survival.tex

vipcard_deps = vipcard.tex emacsver.tex pdflayout.sty
vipcard.pdf: $(vipcard_deps)
	$(ENVADD) pdftex vipcard.tex
vipcard.dvi: $(vipcard_deps)
	$(ENVADD) tex vipcard.tex

vipercard_deps = viperCard.tex emacsver.tex pdflayout.sty
viperCard.pdf: $(vipercard_deps)
	$(ENVADD) pdftex viperCard.tex
viperCard.dvi: $(vipercard_deps)
	$(ENVADD) tex viperCard.tex


.PHONY: clean

clean:
	-rm -f *.dvi *.log *.aux

distclean: clean

## This should really by maintainer-clean, but the handling of the
## refcards is funny.  So abuse extraclean for this.
extraclean: clean
	-rm -f $(PDF_TARGETS) $(PS_TARGETS)

## For the Emacs website.
dist:
	rm -rf emacs-refcards
	mkdir emacs-refcards
	cp Makefile README *.tex gnus-logo.* pdflayout.sty emacs-refcards/
	tar -cf emacs-refcards.tar emacs-refcards
	rm -rf emacs-refcards

### Makefile ends here
