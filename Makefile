CONTENT_DIR ?= content
OUTPUT_DIR ?= output
TEMPLATE_DIR ?= templates
PUBLIC_DIR := $(OUTPUT_DIR)/public

MIRKO := mirko
SECTIONS := $(patsubst $(CONTENT_DIR)/sections/%.md,%, $(wildcard $(CONTENT_DIR)/sections/*.md))
FOOTERS := $(patsubst $(CONTENT_DIR)/footer/%.md,%, $(wildcard $(CONTENT_DIR)/footer/*.md))

MIRKO_TMP := $(patsubst %,$(OUTPUT_DIR)/%, $(MIRKO))
SECTIONS_TMP := $(patsubst %,$(OUTPUT_DIR)/sections/%, $(SECTIONS))
FOOTERS_TMP := $(patsubst %,$(OUTPUT_DIR)/footer/%, $(FOOTERS))
STATIC_OUTPUT := $(patsubst static/%,$(PUBLIC_DIR)/%, $(wildcard static/*))

pandoc = pandoc \
	--from=markdown-auto_identifiers-implicit_figures \
	--to=html \
	--template=$(TEMPLATE_DIR)/$(1).html \
	--output=$(3) \
	--metadata title=$(2) \
	$(4)

.PHONY: all
all: clean $(PUBLIC_DIR)/index.html $(STATIC_OUTPUT)
	rm -rf $(MIRKO_TMP) $(OUTPUT_DIR)/sections $(OUTPUT_DIR)/footer

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

$(OUTPUT_DIR)/sections:
	mkdir -p $(OUTPUT_DIR)/sections

$(OUTPUT_DIR)/footer:
	mkdir -p $(OUTPUT_DIR)/footer

$(PUBLIC_DIR):
	mkdir -p $(PUBLIC_DIR)

$(MIRKO_TMP): $(CONTENT_DIR)/$(MIRKO).md $(OUTPUT_DIR)
	$(call pandoc,$(MIRKO),$(MIRKO),$@) $<

$(OUTPUT_DIR)/sections/%: $(CONTENT_DIR)/sections/%.md $(OUTPUT_DIR)/sections
	$(call pandoc,section,$*,$@,--metadata section=$*) $<

$(OUTPUT_DIR)/footer/%: $(CONTENT_DIR)/footer/%.md $(OUTPUT_DIR)/footer
	$(call pandoc,footer-$*,footer-$*,$@) $<

$(PUBLIC_DIR)/index.html: $(MIRKO_TMP) $(SECTIONS_TMP) $(FOOTERS_TMP) $(PUBLIC_DIR)
	m4 --include=$(OUTPUT_DIR) $(TEMPLATE_DIR)/website.html > $@

$(PUBLIC_DIR)/%: static/% $(PUBLIC_DIR)
	cp -r $< $@

.PHONY: clean
clean:
	find $(OUTPUT_DIR) -not -name $(OUTPUT_DIR) -and -not -name .gitkeep -delete
