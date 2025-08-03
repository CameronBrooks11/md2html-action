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

| Input            | Description                                  | Required | Default         |
| ---------------- | -------------------------------------------- | -------- | --------------- |
| `source-dir`     | Directory containing Markdown files          | No       | `source`        |
| `source-file`    | Single Markdown file to convert (alternative to source-dir) | No | ``              |
| `output-dir`     | Directory where HTML files will be generated | No       | `_website`      |
| `template`       | HTML template to use                         | No       | `default`       |
| `stylesheet`     | CSS stylesheet to use                        | No       | `default`       |
| `site-title`     | Title for the website                        | No       | `Documentation` |
| `base-url`       | Base URL for the site                        | No       | ``              |
| `include-toc`    | Include table of contents                    | No       | `true`          |
| `pandoc-options` | Additional Pandoc options                    | No       | ``              |

### Template Options

- `default` - Use the built-in responsive template
- `path/to/template.html` - Use a custom template from your repository
- `minimal` - Use a minimal built-in template (if available)

### Stylesheet Options

- `default` - Use the built-in responsive stylesheet with dark/light theme
- `path/to/style.css` - Use a custom stylesheet from your repository
- `https://example.com/style.css` - Use a remote stylesheet
- `minimal` - Use a minimal built-in stylesheet (if available)

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

You can provide your own CSS file or use a remote stylesheet. The default stylesheet includes:

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
    template: "api-template.html"
    stylesheet: "https://cdn.jsdelivr.net/gh/sindresorhus/github-markdown-css@main/github-markdown.css"
    pandoc-options: "--highlight-style=tango --toc-depth=4"
```

## Requirements

- Pandoc (automatically installed by the action)
- Python 3.x (for path utilities, automatically available)

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
