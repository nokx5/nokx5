HUGO_OPTS := # Deployement: --baseURL https://nokx5.github.io/golden_cpp/
THEME_VERSION := v0.13.2
THEME_NAME := anubis
CURRENTDIR := $(shell pwd)
DESTINATION := $(CURRENTDIR)/target-doc
THEMEDIR := $(DESTINATION)/themes

.PHONY: doc
serve: clean doc-assets
	mkdir -p $(DESTINATION) && cd $(DESTINATION) && hugo serve  --config=$(CURRENTDIR)/config.toml  --contentDir=$(CURRENTDIR)/content/ --themesDir=$(THEMEDIR) $(HUGO_OPTS) 

.PHONY: doc-assets
doc-assets:
	if ! [ -d $(THEMEDIR)/$(THEME_NAME) ]; then \
	  mkdir -p $(THEMEDIR) ; \
	  ln  $(CURRENTDIR)/themes/$(THEME_NAME) -s $(THEMEDIR)/$(THEME_NAME) ; \
	fi

.PHONY: doc-build
doc-build: doc-assets
	mkdir -p $(DESTINATION) && cd $(DESTINATION) && HUGO_ENV=production hugo --minify --config=$(CURRENTDIR)/config.toml  --contentDir=$(CURRENTDIR)/content/ $(HUGO_OPTS) --themesDir=$(THEMEDIR)

.PHONY: clean
clean:
	rm -rf $(DESTINATION)/public

.PHONY: clean-all
clean-all:
	rm -rf $(DESTINATION)

info:
	echo "STAGING at https://nokx5.github.io/nokx5/ (automatic github action)"
	echo "PRODUCT at https://nokx.ch/portfolio (manual)"
	echo "make doc-build HUGO_OPTS=\"--baseURL https://nokx.ch/portfolio\""
	echo "cd target-doc && mv public portfolio"
	echo "lftp nokx.ch -u s618x_USER"
	echo "# rm -r portfolio"
	echo "# mirror -R portfolio portfolio"
