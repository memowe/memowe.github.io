html:
	mkdir -p public
	cp -r static/* public/
	pandoc \
		--to=html \
		--template=template.html \
		--output=public/index.html \
		content.md
