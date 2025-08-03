#!/bin/bash

# GitHub Action: Markdown to HTML Converter
# Author: Cameron Brooks
# Description: Convert Markdown files to HTML with customizable templates and stylesheets

set -e  # Exit on any error

# Default values
SOURCE_DIR="${INPUT_SOURCE_DIR:-source}"
OUTPUT_DIR="${INPUT_OUTPUT_DIR:-_website}"
TEMPLATE="${INPUT_TEMPLATE:-default}"
STYLESHEET="${INPUT_STYLESHEET:-default}"
SITE_TITLE="${INPUT_SITE_TITLE:-Documentation}"
BASE_URL="${INPUT_BASE_URL:-}"
INCLUDE_TOC="${INPUT_INCLUDE_TOC:-true}"
EXTRA_PANDOC_OPTIONS="${INPUT_PANDOC_OPTIONS:-}"

# Color output functions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ------------------------------------------------------------
# Platform detection and setup
# ------------------------------------------------------------
case "$(uname -s)" in
    Linux*|MINGW*|MSYS*)
        alias sedi="sed -i"
        PLATFORM="linux"
    ;;
    Darwin*|FreeBSD*|OpenBSD*)
        alias sedi="sed -i ''"
        PLATFORM="macos"
    ;;
    *)
        alias sedi="sed -i"
        PLATFORM="linux"
    ;;
esac

# Function to compute relative paths
relpath() {
    python3 -c "import os.path; print(os.path.relpath('$1','$2'))" 2>/dev/null || {
        # Fallback if python3 is not available
        realpath --relative-to="$2" "$1" 2>/dev/null || echo "$1"
    }
}

# ------------------------------------------------------------
# Validate inputs and setup paths
# ------------------------------------------------------------
log_info "Starting Markdown to HTML conversion..."
log_info "Source directory: $SOURCE_DIR"
log_info "Output directory: $OUTPUT_DIR"
log_info "Template: $TEMPLATE"
log_info "Stylesheet: $STYLESHEET"

# Check if source directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    log_error "Source directory '$SOURCE_DIR' does not exist!"
    exit 1
fi

# Count markdown files
MD_FILES=$(find "$SOURCE_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
if [[ "$MD_FILES" -eq 0 ]]; then
    log_warning "No Markdown files found in '$SOURCE_DIR'"
    echo "files-converted=0" >> $GITHUB_OUTPUT
    echo "output-path=$OUTPUT_DIR" >> $GITHUB_OUTPUT
    exit 0
fi

log_info "Found $MD_FILES Markdown file(s) to convert"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# ------------------------------------------------------------
# Setup template
# ------------------------------------------------------------
if [[ "$TEMPLATE" == "default" ]]; then
    TEMPLATE_FILE="$GITHUB_ACTION_PATH/templates/default.html"
    log_info "Using default template"
elif [[ "$TEMPLATE" == "minimal" ]]; then
    TEMPLATE_FILE="$GITHUB_ACTION_PATH/templates/minimal.html"
    log_info "Using minimal template"
elif [[ -f "$TEMPLATE" ]]; then
    TEMPLATE_FILE="$TEMPLATE"
    log_info "Using custom template: $TEMPLATE"
elif [[ -f "$GITHUB_ACTION_PATH/templates/$TEMPLATE.html" ]]; then
    TEMPLATE_FILE="$GITHUB_ACTION_PATH/templates/$TEMPLATE.html"
    log_info "Using built-in template: $TEMPLATE"
elif [[ -f "$GITHUB_ACTION_PATH/templates/$TEMPLATE" ]]; then
    TEMPLATE_FILE="$GITHUB_ACTION_PATH/templates/$TEMPLATE"
    log_info "Using built-in template: $TEMPLATE"
else
    log_error "Template '$TEMPLATE' not found!"
    exit 1
fi

# Verify template file exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    log_error "Template file '$TEMPLATE_FILE' does not exist!"
    exit 1
fi

# ------------------------------------------------------------
# Setup stylesheet
# ------------------------------------------------------------
STYLESHEET_PATH=""
STYLESHEET_URL=""

if [[ "$STYLESHEET" == "default" ]]; then
    # Copy default stylesheet to output directory
    cp "$GITHUB_ACTION_PATH/stylesheets/default.css" "$OUTPUT_DIR/style.css"
    STYLESHEET_PATH="style.css"
    log_info "Using default stylesheet"
elif [[ "$STYLESHEET" == "minimal" ]]; then
    # Copy minimal stylesheet to output directory
    cp "$GITHUB_ACTION_PATH/stylesheets/minimal.css" "$OUTPUT_DIR/style.css"
    STYLESHEET_PATH="style.css"
    log_info "Using minimal stylesheet"
elif [[ "$STYLESHEET" =~ ^https?:// ]]; then
    # Remote stylesheet URL
    STYLESHEET_URL="$STYLESHEET"
    log_info "Using remote stylesheet: $STYLESHEET"
elif [[ -f "$STYLESHEET" ]]; then
    # Local stylesheet file
    STYLESHEET_FILENAME=$(basename "$STYLESHEET")
    cp "$STYLESHEET" "$OUTPUT_DIR/$STYLESHEET_FILENAME"
    STYLESHEET_PATH="$STYLESHEET_FILENAME"
    log_info "Using custom stylesheet: $STYLESHEET"
elif [[ -f "$GITHUB_ACTION_PATH/stylesheets/$STYLESHEET.css" ]]; then
    # Built-in stylesheet
    STYLESHEET_FILENAME="$STYLESHEET.css"
    cp "$GITHUB_ACTION_PATH/stylesheets/$STYLESHEET.css" "$OUTPUT_DIR/$STYLESHEET_FILENAME"
    STYLESHEET_PATH="$STYLESHEET_FILENAME"
    log_info "Using built-in stylesheet: $STYLESHEET"
elif [[ -f "$GITHUB_ACTION_PATH/stylesheets/$STYLESHEET" ]]; then
    # Built-in stylesheet
    STYLESHEET_FILENAME=$(basename "$STYLESHEET")
    cp "$GITHUB_ACTION_PATH/stylesheets/$STYLESHEET" "$OUTPUT_DIR/$STYLESHEET_FILENAME"
    STYLESHEET_PATH="$STYLESHEET_FILENAME"
    log_info "Using built-in stylesheet: $STYLESHEET"
else
    log_error "Stylesheet '$STYLESHEET' not found!"
    exit 1
fi

# ------------------------------------------------------------
# Build Pandoc command options
# ------------------------------------------------------------
PANDOC_OPTS=(
    "--template=$TEMPLATE_FILE"
    "--standalone"
)

# Add table of contents if requested
if [[ "$INCLUDE_TOC" == "true" ]]; then
    PANDOC_OPTS+=("--table-of-contents" "--toc-depth=3")
fi

# Add extra options if provided
if [[ -n "$EXTRA_PANDOC_OPTIONS" ]]; then
    # Split extra options by space and add them
    IFS=' ' read -ra EXTRA_OPTS <<< "$EXTRA_PANDOC_OPTIONS"
    for opt in "${EXTRA_OPTS[@]}"; do
        PANDOC_OPTS+=("$opt")
    done
fi

# Add metadata
PANDOC_OPTS+=(
    "--metadata=site-title:$SITE_TITLE"
    "--metadata=base-url:$BASE_URL"
)

if [[ -n "$STYLESHEET_PATH" ]]; then
    PANDOC_OPTS+=("--metadata=stylesheet:$STYLESHEET_PATH")
fi

if [[ -n "$STYLESHEET_URL" ]]; then
    PANDOC_OPTS+=("--metadata=stylesheet-url:$STYLESHEET_URL")
fi

# ------------------------------------------------------------
# Convert Markdown files
# ------------------------------------------------------------
FILES_CONVERTED=0

log_info "Converting Markdown files..."

# Find and convert all markdown files
while IFS= read -r -d '' md_file; do
    # Get relative path from source directory
    rel_path=$(relpath "$md_file" "$SOURCE_DIR")
    
    # Create output path with .html extension
    html_file="$OUTPUT_DIR/${rel_path%.md}.html"
    
    # Create output directory if it doesn't exist
    mkdir -p "$(dirname "$html_file")"
    
    # Calculate relative path for assets
    output_dir_rel=$(dirname "$html_file")
    rel_to_root=$(relpath "$OUTPUT_DIR" "$output_dir_rel")
    
    log_info "Converting: $rel_path"
    
    # Convert the file
    if pandoc "$md_file" "${PANDOC_OPTS[@]}" \
        --metadata="rel_path:$rel_to_root" \
        --output="$html_file"; then
        
        FILES_CONVERTED=$((FILES_CONVERTED + 1))
        log_success "✓ $rel_path → ${html_file#$OUTPUT_DIR/}"
    else
        log_error "✗ Failed to convert $rel_path"
        exit 1
    fi
    
done < <(find "$SOURCE_DIR" -name "*.md" -type f -print0)

# ------------------------------------------------------------
# Copy additional assets
# ------------------------------------------------------------
log_info "Copying additional assets..."

# Copy media files (images, etc.)
if [[ -d "$SOURCE_DIR/media" ]]; then
    cp -r "$SOURCE_DIR/media" "$OUTPUT_DIR/"
    log_success "Copied media directory"
fi

# Copy any other common asset directories
for asset_dir in "images" "assets" "static" "files"; do
    if [[ -d "$SOURCE_DIR/$asset_dir" ]]; then
        cp -r "$SOURCE_DIR/$asset_dir" "$OUTPUT_DIR/"
        log_success "Copied $asset_dir directory"
    fi
done

# ------------------------------------------------------------
# Generate index if it doesn't exist
# ------------------------------------------------------------
if [[ ! -f "$OUTPUT_DIR/index.html" ]] && [[ -f "$SOURCE_DIR/README.md" ]]; then
    log_info "Generating index.html from README.md"
    pandoc "$SOURCE_DIR/README.md" "${PANDOC_OPTS[@]}" \
        --metadata="rel_path:." \
        --output="$OUTPUT_DIR/index.html"
    FILES_CONVERTED=$((FILES_CONVERTED + 1))
    log_success "Generated index.html"
fi

# ------------------------------------------------------------
# Output results
# ------------------------------------------------------------
log_success "Conversion completed!"
log_info "Files converted: $FILES_CONVERTED"
log_info "Output directory: $OUTPUT_DIR"

# Set GitHub Actions outputs
echo "files-converted=$FILES_CONVERTED" >> $GITHUB_OUTPUT
echo "output-path=$OUTPUT_DIR" >> $GITHUB_OUTPUT

# List generated files
log_info "Generated files:"
find "$OUTPUT_DIR" -name "*.html" -type f | while read -r file; do
    echo "  - ${file#$OUTPUT_DIR/}"
done
