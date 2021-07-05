.PHONY: all prepare website mirko sections footer static clean

all: prepare website

prepare: clean
	mkdir -p \
		output/sections \
		output/footer \
		output/public

website: static mirko sections footer
	m4	\
		--include=output \
		templates/website.html \
		> output/public/index.html

static:
	cp -r static/* output/public/

mirko:
	pandoc \
		--from=markdown-auto_identifiers-implicit_figures \
		--to=html \
		--template=templates/mirko.html \
		--metadata title=mirko \
		--output=output/mirko \
		content/mirko.md

sections:
	for section in dh dance software ; do \
		pandoc \
			--from=markdown-auto_identifiers-implicit_figures \
			--to=html \
			--template=templates/section.html \
			--metadata title=$$section \
			--metadata section=$$section \
			--output=output/sections/$$section \
			content/$$section.md ; \
	done

footer:
	for part in copyright legal icons ; do \
		pandoc \
			--from=markdown-auto_identifiers-implicit_figures \
			--to=html \
			--template=templates/footer-$${part}.html \
			--metadata title=footer-$$part \
			--output=output/footer/$$part \
			content/footer-$$part.md ; \
	done

clean:
	find output -not -name output -and -not -name .gitkeep -delete
