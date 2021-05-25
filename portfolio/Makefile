HUGO_OPTS := # Deployement: --baseURL https://www.nokx.ch
THEME_NAME := etch
CURRENTDIR := $(shell pwd)
DESTINATION := $(CURRENTDIR)
THEMEDIR := $(CURRENTDIR)/themes

.PHONY: doc
serve: clean doc-assets
	mkdir -p $(DESTINATION) && cd $(DESTINATION) && hugo serve  --config=$(CURRENTDIR)/config.toml  --contentDir=$(CURRENTDIR)/content/ --themesDir=$(THEMEDIR) $(HUGO_OPTS) 

.PHONY: doc-assets
doc-assets: # https://github.com/LukasJoswiak/etch.git
	if ! [ -d $(THEMEDIR)/$(THEME_NAME) ]; then \
	  mkdir -p $(THEMEDIR)/$(THEME_NAME)/ ; \
	fi

.PHONY: doc-build
doc-build: doc-assets
	mkdir -p $(DESTINATION) && cd $(DESTINATION) && HUGO_ENV=production hugo --minify --config=$(CURRENTDIR)/config.toml  --contentDir=$(CURRENTDIR)/content/ $(HUGO_OPTS) --themesDir=$(THEMEDIR)

.PHONY: clean
clean:
	rm -rf $(DESTINATION)/public
	rm -rf $(DESTINATION)/resources
