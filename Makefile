mypweave = /Users/chabot/Library/Enthought/Canopy_64bit/User/bin/Pweave
mylatexmk = /usr/texbin/latexmk
output = 2014-08-29-euroscipy-pambox-poster.pdf
proc = texminted


DOT_OUTDIR := figures
DOT_SRCDIR := dot
DOTFILES := $(addprefix $(DOT_OUTDIR)/,lavandier.pdf beutelmann2010.pdf)

.PHONY = all, withcache, cache

all: $(output)

dotfiles: $(DOTFILES)

$(DOT_OUTDIR)/%.pdf : $(DOT_SRCDIR)/%.dot
	dot -Tpdf $< -o $@

$(DOTFILES): | $(DOT_OUTDIR)

$(DOT_OUTDIR):
	mkdir $(DOT_OUTDIR)

# Make article
%.pdf: %.texw dotfiles
	$(mypweave) -c -f $(proc) $(<)
	$(mylatexmk) -pdf -pv -silent $(<:.texw=.tex)

# Use cached python blocks
withcache: dotfiles 
	$(mypweave) -d -f $(texpweave) $(output:.pdf=.texw)
	$(mylatexmk) -pdf -pv -silent $(output:.pdf=.tex)

# Cache the output of the python blocks
cache: $(output:.pdf=.texw)
	$(mypweave) --cache-results -f $(proc) $(output:.pdf=.texw)

clean:
	$(mylatexmk) -C 
