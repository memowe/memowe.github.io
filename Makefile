.PHONY: website mirko sections footer static clean

website: clean mirko sections footer static
	m4	\
		--include=output \
		templates/website.html \
		> output/public/index.html

mirko:
	pandoc \
		--to=html \
		--template=templates/mirko.html \
		--metadata title=mirko \
		--output=output/mirko \
		content/mirko.md

sections:
	for section in dh dance software ; do \
		pandoc \
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
			--to=html \
			--template=templates/footer-$${part}.html \
			--metadata title=footer-$$part \
			--output=output/footer/$$part \
			content/footer-$$part.md ; \
	done

static:
	for dir in fonts images style ; do \
		cp -r $$dir output/public/ ; \
	done
	cp *.asc output/public/

clean:
	rm -rf \
		output/mirko \
		output/sections/* \
		output/footer/* \
		output/public/* \
