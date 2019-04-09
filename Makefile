html:
	mkdir -p public
	pandoc \
		--to=html \
		--template=template.html \
		--output=public/index.html \
		content.md
