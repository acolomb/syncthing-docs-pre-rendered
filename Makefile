SOURCE_DIR = ~/src/syncthing-docs
TARGET_DIR := $(CURDIR)
VERSIONS = $(wildcard v*.*.*)
JS_FILES = $(patsubst %,%/_static/version_redirect.js,$(VERSIONS))


all: $(VERSIONS)

copy-js: $(JS_FILES)
	git add --no-all .

.PHONY: all copy-js


$(VERSIONS): %: $(TARGET_DIR)/inject-version-picker.patch FORCE
	cd $(SOURCE_DIR) && \
	git checkout -f $@ && \
	git apply --index --verbose $< && \
	make clean html man && \
	rm -rf $(TARGET_DIR)/$@ && \
        mv -v _build/html/ $(TARGET_DIR)/$@ && \
        mv -v _build/man/ $(TARGET_DIR)/$@/ && \
	cd $(TARGET_DIR) && \
	git add --no-all $@

$(JS_FILES): %/_static/version_redirect.js: FORCE
	cp $(SOURCE_DIR)/_static/version_redirect.js $(TARGET_DIR)/$@

FORCE:
