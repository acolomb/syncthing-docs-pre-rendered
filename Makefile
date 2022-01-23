SOURCE_DIR = ~/src/syncthing-docs/
TARGET_DIR := $(CURDIR)
VERSIONS = $(wildcard v*.*.*)


all: $(VERSIONS)

.PHONY: all


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

FORCE:
