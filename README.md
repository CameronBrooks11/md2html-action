# Markdown to HTML Action

A GitHub Action that converts Markdown files to HTML using Pandoc with customizable templates and stylesheets.

## Features

- 📝 **Pure Markdown support** - No frontmatter required!
- 🔧 Convert Markdown files to HTML using Pandoc
- 🎨 Customizable HTML templates (default provided or bring your own)
- 💅 Flexible stylesheet options (default, custom, or remote CSS)
- 📱 Responsive design with dark/light theme support
- 🔗 Automatic table of contents generation
- 📁 Preserves directory structure and converts entire directories
- 📄 Single file conversion support for individual Markdown files
- 🖼️ Copies media and asset files
- 🏷️ Open Graph meta tags for social sharing
- ⚡ Fast and reliable conversion

## 🎨 Live Demo Gallery

**[View Live Demos →](https://cameronbrooks11.github.io/md2html-action/demos/)**

See the action in action! The demo gallery showcases different templates and styling options:

### Built-in Themes

- **[Default Theme](https://cameronbrooks11.github.io/md2html-action/demos/default/)** - Clean, professional layout with navigation header, table of contents, and responsive design with dark/light mode support
- **[Minimal Theme](https://cameronbrooks11.github.io/md2html-action/demos/minimal/)** - Streamlined design focused on content readability with minimal styling overhead
- **[Academic Theme](https://cameronbrooks11.github.io/md2html-action/demos/academic/)** - Elegant serif typography designed for scholarly documentation, research papers, and academic content
- **[Technical Theme](https://cameronbrooks11.github.io/md2html-action/demos/technical/)** - GitHub-inspired clean interface optimized for API documentation and technical guides with alert callouts
- **[Blog Theme](https://cameronbrooks11.github.io/md2html-action/demos/blog/)** - Elegant blog-style layout with beautiful typography, perfect for articles and tutorials
- **[Corporate Theme](https://cameronbrooks11.github.io/md2html-action/demos/corporate/)** - Professional business styling with corporate color scheme for enterprise documentation

> **Note:** All demos use the same markdown content with different stylesheets to showcase theme variety

### Remote CSS Examples

- **[GitHub CSS Demo](https://cameronbrooks11.github.io/md2html-action/demos/github/)** - Uses `github` template with remote GitHub markdown CSS from CDN

> **Note:** The GitHub demo showcases how to use remote CSS by combining the `github` template with the official GitHub markdown CSS (`https://cdn.jsdelivr.net/npm/github-markdown-css@5.1.0/github-markdown.min.css`)

## Usage

### Basic Usage

```yaml
name: Build Documentation
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Convert Markdown to HTML
        uses: CameronBrooks11/md2html-action@v1
        with:
          source-dir: "docs"
          output-dir: "website"
```

### Single File Usage

Convert a single Markdown file (great for README to GitHub Pages):

```yaml
- name: Convert README to HTML
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-file: "README.md"
    output-dir: "_site"
    template: "default"
```

### Advanced Usage

```yaml
name: Build and Deploy Docs
on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Convert Markdown to HTML
        id: convert
        uses: CameronBrooks11/md2html-action@v1
        with:
          source-dir: "docs"
          output-dir: "_site"
          template: "custom-template.html"
          stylesheet: "https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css"
          site-title: "My Documentation"
          base-url: "https://mysite.github.io/my-repo"
          include-toc: "true"
          pandoc-options: "--highlight-style=tango"

      - name: Deploy to GitHub Pages
        uses: actions/deploy-pages@v4
        with:
          path: ${{ steps.convert.outputs.output-path }}
```

## Inputs

| Input            | Description                                                 | Required | Default         |
| ---------------- | ----------------------------------------------------------- | -------- | --------------- |
| `source-dir`     | Directory containing Markdown files                         | No       | `source`        |
| `source-file`    | Single Markdown file to convert (alternative to source-dir) | No       | ``              |
| `output-dir`     | Directory where HTML files will be generated                | No       | `_website`      |
| `template`       | HTML template to use                                        | No       | `default`       |
| `stylesheet`     | CSS stylesheet to use                                       | No       | `default`       |
| `site-title`     | Title for the website                                       | No       | `Documentation` |
| `base-url`       | Base URL for the site                                       | No       | ``              |
| `include-toc`    | Include table of contents                                   | No       | `true`          |
| `pandoc-options` | Additional Pandoc options                                   | No       | ``              |

### Template Options

- `default` - Use the built-in responsive template
- `minimal` - Use a minimal built-in template
- `github` - Use a GitHub-style template (pairs well with github stylesheet)
- `path/to/template.html` - Use a custom template from your repository

### Stylesheet Options

- `default` - Use the built-in responsive stylesheet with dark/light theme
- `minimal` - Use a minimal built-in stylesheet
- `academic` - Professional scholarly documentation style with serif fonts
- `technical` - Modern technical documentation with clean typography
- `blog` - Personal blog and article styling with elegant design
- `corporate` - Professional business documentation styling
- `path/to/style.css` - Use a custom stylesheet from your repository
- `https://example.com/style.css` - Use a remote stylesheet (e.g., GitHub CSS)

## Outputs

| Output            | Description                      |
| ----------------- | -------------------------------- |
| `output-path`     | Path to the generated HTML files |
| `files-converted` | Number of files converted        |

## Directory Structure

Your repository should be structured like this:

```
your-repo/
├── docs/                    # Source Markdown files
│   ├── index.md            # Will become index.html
│   ├── getting-started.md
│   ├── advanced/
│   │   └── configuration.md
│   └── media/              # Images and assets
│       ├── screenshot.png
│       └── favicon.ico
├── custom-template.html    # Optional custom template
├── custom-style.css       # Optional custom stylesheet
└── .github/
    └── workflows/
        └── docs.yml        # Your workflow file
```

After conversion:

```
_website/                   # Generated HTML files
├── index.html
├── getting-started.html
├── advanced/
│   └── configuration.html
├── media/                  # Copied assets
│   ├── screenshot.png
│   └── favicon.ico
└── style.css              # Stylesheet
```

## Markdown Features Supported

- **Pure Markdown** - No frontmatter required!
- Standard Markdown syntax
- Tables
- Code blocks with syntax highlighting
- Math expressions (with appropriate Pandoc options)
- Footnotes
- Task lists
- Strikethrough
- Optional YAML frontmatter for custom metadata

### Optional YAML Frontmatter

Frontmatter is **completely optional** but can be used for custom metadata:

```yaml
---
title: "Custom Page Title"
description: "Page description for SEO"
author: "Your Name"
date: "2025-01-01"
keywords: ["documentation", "markdown", "html"]
navbar_home: true
---
# Your content here...
```

## Custom Templates

You can create your own Pandoc template. The template should be an HTML file with Pandoc template variables. Key variables include:

- `$title$` - Page title
- `$body$` - Converted Markdown content
- `$toc$` / `$table-of-contents$` - Table of contents
- `$site-title$` - Site title from inputs
- `$rel_path$` - Relative path to root (for assets)
- `$stylesheet$` - Stylesheet path
- `$stylesheet-url$` - Remote stylesheet URL

See the [default template](templates/default.html) for a complete example.

## Custom Stylesheets

You can provide your own CSS file or use a remote stylesheet. The action includes several built-in stylesheets for different use cases:

### Built-in Stylesheet Themes

#### `default` - Responsive Dark/Light Theme

- Modern responsive design with automatic dark/light mode detection
- Professional layout with fixed header and sidebar TOC
- Comprehensive styling for all markdown elements
- Optimized for technical documentation

#### `minimal` - Clean and Simple

- Lightweight design with minimal styling
- Fast loading and clean typography
- Perfect for simple documents and quick conversions
- Mobile-first responsive design

#### `academic` - Scholarly Documentation

- Elegant serif typography (Crimson Text, Libre Baskerville)
- Professional academic paper styling
- Enhanced readability with justified text and proper spacing
- Sophisticated color scheme with accent highlights
- Right-aligned table of contents

#### `technical` - Modern Technical Docs

- GitHub-inspired clean interface
- Optimized for API documentation and technical guides
- Monospace code styling with syntax highlighting support
- Alert callouts for info, warning, success, and error messages
- Sticky sidebar navigation

#### `blog` - Personal Blog Style

- Elegant blog-style layout with serif headings (Playfair Display)
- Beautiful typography with Inter font family
- Gradient headers and stylized elements
- Perfect for articles, tutorials, and personal documentation
- Engaging visual design with hover effects

#### `corporate` - Business Documentation

- Professional business styling with corporate color scheme
- Clean, authoritative design suitable for enterprise documentation
- Structured layout with clear hierarchy
- Professional callouts and formatted tables
- Sticky TOC for easy navigation

### Usage Examples

```yaml
# Use academic styling for research documentation
- name: Build Academic Documentation
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "research"
    stylesheet: "academic"
    template: "default"

# Use technical styling for API docs
- name: Build API Documentation
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "api-docs"
    stylesheet: "technical"
    template: "default"

# Use blog styling for articles
- name: Build Blog Posts
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "posts"
    stylesheet: "blog"
    template: "default"

# Use GitHub styling with remote CSS and GitHub template
- name: Build GitHub-style Documentation
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "docs"
    stylesheet: "https://cdn.jsdelivr.net/npm/github-markdown-css@5.1.0/github-markdown.min.css"
    template: "github"
```

The default stylesheet includes:

- Responsive design
- Dark/light theme support
- Clean typography
- Code syntax highlighting
- Print styles
- Accessible design

## Examples

### Documentation Site

Perfect for project documentation:

```yaml
- name: Build Documentation
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "docs"
    output-dir: "public"
    site-title: "Project Documentation"
    base-url: "https://myproject.github.io"
    include-toc: "true"
```

### Blog

Convert Markdown blog posts:

```yaml
- name: Build Blog
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "posts"
    output-dir: "blog"
    template: "blog-template.html"
    stylesheet: "blog-style.css"
    site-title: "My Blog"
```

### API Documentation

With custom styling:

```yaml
- name: Build API Docs
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "api-docs"
    template: "default"
    stylesheet: "technical"
    pandoc-options: "--highlight-style=tango --toc-depth=4"
```

### Academic Papers

For scholarly documentation:

```yaml
- name: Build Research Documentation
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "research"
    template: "default"
    stylesheet: "academic"
    site-title: "Research Documentation"
```

### Corporate Documentation

For business and enterprise docs:

```yaml
- name: Build Corporate Docs
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "docs"
    template: "default"
    stylesheet: "corporate"
    site-title: "Company Documentation"
```

## Requirements

- Pandoc (automatically installed by the action)
- Python 3.x (for path utilities, automatically available)

## Local Testing with Act

You can test this action locally using [act](https://github.com/nektos/act) to run GitHub Actions workflows on your machine.

### Prerequisites

1. **Install Docker** (required by act)
2. **Install act** via GitHub CLI:

   ```bash
   gh extension install https://github.com/nektos/gh-act
   ```

### Testing Commands

#### List Available Workflows

```bash
# See all available workflows and jobs
gh act --list
```

#### Test Individual Jobs

```bash
# Test default configuration
gh act -j test-default-configuration --bind

# Test custom configuration with minimal template
gh act -j test-custom-configuration --bind

# Test remote CSS integration
gh act -j test-remote-css --bind

# Test new stylesheet themes
gh act -j test-academic-style --bind
gh act -j test-technical-style --bind
gh act -j test-blog-style --bind
gh act -j test-corporate-style --bind
```

#### Test Entire Workflows

```bash
# Test the integration test workflow (all 7 stylesheet configurations)
gh act -W .github/workflows/integration-tests.yml --bind

# Test GitHub Pages workflow (converts README.md to website)
gh act -W .github/workflows/readme-to-github-pages.yml --bind

# Test cross-platform and release workflow (if available)
gh act -W .github/workflows/cross-platform-tests-and-release.yml
```

#### Quick Test Commands

```bash
# Run all integration tests
gh act -W .github/workflows/integration-tests.yml --bind

# Test a specific stylesheet theme
gh act -j test-academic-style --bind

# Test all themes at once (will run all 7 test jobs)
gh act
```

### Viewing Test Output

After running `act` with `--bind`, the generated HTML files will be available in your local directory:

```bash
# View default theme output
cd outputs-default-configuration && python -m http.server 8000

# View minimal theme output
cd outputs-custom-configuration && python -m http.server 8001

# View academic theme output
cd outputs-academic-style && python -m http.server 8002

# View technical theme output
cd outputs-technical-style && python -m http.server 8003

# View blog theme output
cd outputs-blog-style && python -m http.server 8004

# View corporate theme output
cd outputs-corporate-style && python -m http.server 8005

# View GitHub theme output
cd outputs-remote-css && python -m http.server 8006
```

Then open your browser to the respective localhost URL (e.g., `http://localhost:8000`) to view the generated HTML files.

### Testing Your Changes

1. Make changes to templates, stylesheets, or the conversion script
2. Run `gh act -j test-default-configuration --bind` to test locally
3. View the output in your browser using the local server
4. Iterate until satisfied, then commit and push

This allows you to test the action completely offline before pushing changes to GitHub!

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [Pandoc](https://pandoc.org/)
- Inspired by various documentation generators
- Uses GitHub Actions for automation
