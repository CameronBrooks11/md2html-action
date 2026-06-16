#!/bin/bash

# GitHub Action: Markdown to HTML Converter
# Author: Cameron Brooks
# Description: Convert Markdown files to HTML with customizable templates and stylesheets

set -e  # Exit on any error

# Default values
SOURCE_DIR="${INPUT_SOURCE_DIR:-source}"
SOURCE_FILE="${INPUT_SOURCE_FILE:-}"
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

# Function to compute relative paths
# Paths are passed as argv (sys.argv) to avoid shell-injection via string interpolation.
relpath() {
    # python3 is pre-installed on all GitHub-hosted runners
    python3 -c "import sys, os.path; print(os.path.relpath(sys.argv[1], sys.argv[2]))" "$1" "$2" 2>/dev/null && return
    # fallback for environments where python3 is aliased as python
    python -c "import sys, os.path; print(os.path.relpath(sys.argv[1], sys.argv[2]))" "$1" "$2" 2>/dev/null && return
    # GNU realpath fallback (Linux runners)
    realpath --relative-to="$2" "$1" 2>/dev/null && return
    # last resort: strip common prefix (only safe for direct children)
    echo "${1#"$2"/}"
}

# Split a string into argv tokens the way a POSIX shell would (honoring quotes),
# WITHOUT eval — eval would execute $(...) or backticks embedded in the input.
# Tokens are emitted NUL-separated so they read safely into a bash array.
shlex_split() {
    python3 -c "import sys, shlex; sys.stdout.write(''.join(t + chr(0) for t in shlex.split(sys.stdin.read())))" 2>/dev/null && return
    python -c "import sys, shlex; sys.stdout.write(''.join(t + chr(0) for t in shlex.split(sys.stdin.read())))"
}

# Function to extract title from first H1 heading in markdown file
extract_title() {
    local md_file="$1"
    # Look for the first H1 heading (# Title) and extract the title text
    local title
    title=$(grep -m 1 '^# ' "$md_file" 2>/dev/null | sed 's/^# *//' | sed 's/ *$//')
    if [[ -n "$title" ]]; then
        echo "$title"
    else
        # Fallback to filename without extension
        basename "$md_file" .md
    fi
}

# ------------------------------------------------------------
# Validate inputs and setup paths
# ------------------------------------------------------------
log_info "Starting Markdown to HTML conversion..."

# Determine if we're processing a single file or directory
if [[ -n "$SOURCE_FILE" ]]; then
    log_info "Source file: $SOURCE_FILE"
    if [[ ! -f "$SOURCE_FILE" ]]; then
        log_error "Source file '$SOURCE_FILE' does not exist!"
        exit 1
    fi
    MD_FILES=1
    SINGLE_FILE_MODE=true
else
    log_info "Source directory: $SOURCE_DIR"
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log_error "Source directory '$SOURCE_DIR' does not exist!"
        exit 1
    fi
    # Path to prune so a nested output directory (e.g. source-dir "." with
    # output-dir "_site") is never picked up and re-converted on later runs.
    OUTPUT_PRUNE_PATH="$SOURCE_DIR/$(relpath "$OUTPUT_DIR" "$SOURCE_DIR")"
    # Count markdown files (excluding the output directory)
    MD_FILES=$(find "$SOURCE_DIR" -path "$OUTPUT_PRUNE_PATH" -prune -o -name "*.md" -type f -print | wc -l | tr -d ' ')
    SINGLE_FILE_MODE=false
fi

log_info "Output directory: $OUTPUT_DIR"
log_info "Template: $TEMPLATE"
log_info "Stylesheet: $STYLESHEET"
if [[ "$MD_FILES" -eq 0 ]]; then
    log_warning "No Markdown files found in '$SOURCE_DIR'"
    echo "files-converted=0" >> "$GITHUB_OUTPUT"
    echo "output-path=$OUTPUT_DIR" >> "$GITHUB_OUTPUT"
    exit 0
fi

log_info "Found $MD_FILES Markdown file(s) to convert"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# ------------------------------------------------------------
# Setup template
# ------------------------------------------------------------

# Auto-detect GitHub CSS and use GitHub template
if [[ "$STYLESHEET" =~ github-markdown-css ]] && [[ "$TEMPLATE" == "default" ]]; then
    TEMPLATE_FILE="$GITHUB_ACTION_PATH/templates/github.html"
    log_info "Auto-detected GitHub CSS - using GitHub-compatible template"
elif [[ "$TEMPLATE" == "default" ]]; then
    TEMPLATE_FILE="$GITHUB_ACTION_PATH/templates/default.html"
    log_info "Using default template"
elif [[ "$TEMPLATE" == "minimal" ]]; then
    TEMPLATE_FILE="$GITHUB_ACTION_PATH/templates/minimal.html"
    log_info "Using minimal template"
elif [[ "$TEMPLATE" == "github" ]]; then
    TEMPLATE_FILE="$GITHUB_ACTION_PATH/templates/github.html"
    log_info "Using GitHub-compatible template"
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
    cp "$GITHUB_ACTION_PATH/stylesheets/$STYLESHEET.css" "$OUTPUT_DIR/style.css"
    STYLESHEET_PATH="style.css"
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
    "--shift-heading-level-by=0"
    "--mathjax=https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"
    "--highlight-style=zenburn"
)

# Add table of contents if requested
if [[ "$INCLUDE_TOC" == "true" ]]; then
    PANDOC_OPTS+=("--table-of-contents" "--toc-depth=3")
fi

# Add extra options if provided.
# Split with shlex (honors quotes) rather than eval, so embedded $(...) or
# backticks in the pandoc-options input are NOT executed.
if [[ -n "$EXTRA_PANDOC_OPTIONS" ]]; then
    while IFS= read -r -d '' opt; do
        PANDOC_OPTS+=("$opt")
    done < <(printf '%s' "$EXTRA_PANDOC_OPTIONS" | shlex_split)
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

if [[ "$SINGLE_FILE_MODE" == "true" ]]; then
    # Single file mode
    filename=$(basename "$SOURCE_FILE" .md)
    html_file="$OUTPUT_DIR/${filename}.html"
    
    # Create output directory if it doesn't exist
    mkdir -p "$OUTPUT_DIR"
    
    log_info "Converting: $(basename "$SOURCE_FILE")"
    
    # Extract title from the markdown file
    extracted_title=$(extract_title "$SOURCE_FILE")
    log_info "Extracted title: $extracted_title"
    
    # Convert the single file
    if pandoc "$SOURCE_FILE" "${PANDOC_OPTS[@]}" \
        --metadata="rel_path:." \
        --metadata="title:$extracted_title" \
        --output="$html_file"; then
        
        FILES_CONVERTED=1
        log_success "✓ $(basename "$SOURCE_FILE") → ${filename}.html"
    else
        log_error "✗ Failed to convert $(basename "$SOURCE_FILE")"
        exit 1
    fi
else
    # Directory mode - Find and convert all markdown files
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
        
        # Extract title from the markdown file
        extracted_title=$(extract_title "$md_file")
        
        # Convert the file
        if pandoc "$md_file" "${PANDOC_OPTS[@]}" \
            --metadata="rel_path:$rel_to_root" \
            --metadata="title:$extracted_title" \
            --output="$html_file"; then
            
            FILES_CONVERTED=$((FILES_CONVERTED + 1))
            log_success "✓ $rel_path → ${html_file#"$OUTPUT_DIR"/}"
        else
            log_error "✗ Failed to convert $rel_path"
            exit 1
        fi
        
    done < <(find "$SOURCE_DIR" -path "$OUTPUT_PRUNE_PATH" -prune -o -name "*.md" -type f -print0)
fi

# ------------------------------------------------------------
# Fix markdown links to point to HTML files
# ------------------------------------------------------------
log_info "Fixing internal markdown links..."

# Find all HTML files and fix .md links to .html links.
# Two sed expressions handle both double-quoted and single-quoted href attributes.
find "$OUTPUT_DIR" -name "*.html" -type f | while read -r html_file; do
    case "$(uname -s)" in
        Darwin*|FreeBSD*|OpenBSD*)
            sed -i '' \
                -e 's/href="\([^"]*\)\.md"/href="\1.html"/g' \
                -e "s/href='\([^']*\)\.md'/href='\1.html'/g" \
                "$html_file"
        ;;
        *)
            sed -i \
                -e 's/href="\([^"]*\)\.md"/href="\1.html"/g' \
                -e "s/href='\([^']*\)\.md'/href='\1.html'/g" \
                "$html_file"
        ;;
    esac
done

log_success "Fixed internal markdown links"

# ------------------------------------------------------------
# Copy additional assets (media/images/assets/static/files) that live
# alongside the source. In directory mode this is the source directory; in
# single-file mode it is the directory that contains the source file, so that
# relative image/asset links in the generated HTML still resolve.
# ------------------------------------------------------------
if [[ "$SINGLE_FILE_MODE" == "true" ]]; then
    ASSET_BASE=$(dirname "$SOURCE_FILE")
else
    ASSET_BASE="$SOURCE_DIR"
fi

log_info "Copying additional assets from '$ASSET_BASE'..."
for asset_dir in "media" "images" "assets" "static" "files"; do
    if [[ -d "$ASSET_BASE/$asset_dir" ]]; then
        cp -r "$ASSET_BASE/$asset_dir" "$OUTPUT_DIR/"
        log_success "Copied $asset_dir directory"
    fi
done

# ------------------------------------------------------------
# Generate index if it doesn't exist (directory mode only)
# ------------------------------------------------------------
if [[ "$SINGLE_FILE_MODE" == "false" ]]; then
    if [[ ! -f "$OUTPUT_DIR/index.html" ]] && [[ -f "$OUTPUT_DIR/README.html" ]]; then
        log_info "Generating index.html from README.html"
        
        # README.md was already converted (and link-fixed) in the loop above, so
        # copy that output instead of re-running pandoc here. Re-running after the
        # link-rewrite pass would leave the landing page's .md links unrewritten.
        cp "$OUTPUT_DIR/README.html" "$OUTPUT_DIR/index.html"
        FILES_CONVERTED=$((FILES_CONVERTED + 1))
        log_success "Generated index.html"
    fi
fi

# ------------------------------------------------------------
# Output results
# ------------------------------------------------------------
log_success "Conversion completed!"
log_info "Files converted: $FILES_CONVERTED"
log_info "Output directory: $OUTPUT_DIR"

# Set GitHub Actions outputs
echo "files-converted=$FILES_CONVERTED" >> "$GITHUB_OUTPUT"
echo "output-path=$OUTPUT_DIR" >> "$GITHUB_OUTPUT"

# List generated files
log_info "Generated files:"
find "$OUTPUT_DIR" -name "*.html" -type f | while read -r file; do
    echo "  - ${file#"$OUTPUT_DIR"/}"
done
