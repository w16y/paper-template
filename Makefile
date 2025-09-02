# Makefile for building research bulletin papers
# Usage: make [target] [INPUT=file.md] [TIMESTAMP=false]

# Default input file
INPUT ?= template.md

# Output configuration
OUTPUT_NAME = $(basename $(INPUT))
ifeq ($(TIMESTAMP),false)
  OUTPUT_FILE = $(OUTPUT_DIR)/$(OUTPUT_NAME).docx
else
  TIMESTAMP_VALUE = $(shell date +%Y%m%d_%H%M%S)
  OUTPUT_FILE = $(OUTPUT_DIR)/$(OUTPUT_NAME)_$(TIMESTAMP_VALUE).docx
endif
OUTPUT_DIR = output

# Pandoc configuration
PANDOC_FLAGS = -F pandoc-crossref \
	--citeproc \
	--reference-doc=config/_hinagata-horizontal-ja.docx \
	--lua-filter=config/_pagebreak.lua \
	--bibliography=cite.yaml \
	--csl=config/_ieee.csl \
	--metadata-file=config/_output.yaml \
	--metadata-file=config/_crossref.yaml \
	--number-sections

# Docker configuration
DOCKER_IMAGE = pandoc/core:latest
DOCKER_RUN = docker run --rm -v "$(shell pwd):/data" -w /data $(DOCKER_IMAGE)

# Default target
.PHONY: all
all: build

# Build the document (using Docker)
.PHONY: build
build:
	@echo "Building $(INPUT)..."
	@mkdir -p $(OUTPUT_DIR)
	$(DOCKER_RUN) $(INPUT) $(PANDOC_FLAGS) -o "$(OUTPUT_FILE)"
	@echo "Output: $(OUTPUT_FILE)"


# Clean output directory
.PHONY: clean
clean:
	@echo "Cleaning output directory..."
	@rm -rf $(OUTPUT_DIR)/*

# Show help
.PHONY: help
help:
	@echo "Usage: make [target] [INPUT=file.md] [TIMESTAMP=false]"
	@echo ""
	@echo "Targets:"
	@echo "  build  - Build DOCX (default)"
	@echo "  clean  - Clean output directory"
	@echo "  help   - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make                         # Build with timestamp"
	@echo "  make TIMESTAMP=false         # Build without timestamp"
	@echo "  make INPUT=paper.md          # Build specific file"
	@echo ""
	@echo "Note: All builds use Docker (pandoc/core:latest)"