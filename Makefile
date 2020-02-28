html:
	mkdir -p public
	cp meta.ttf public/
	cp bg-wwu.png public/
	pandoc \
		--to=html \
		--template=template.html \
		--output=public/index.html \
		content.md
