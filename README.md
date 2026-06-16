# Markdown to HTML Action

A GitHub Action that converts Markdown to HTML with Pandoc, using customizable templates and stylesheets.

## Features

- Converts Markdown to HTML with Pandoc — no frontmatter required
- Built-in templates (`default`, `minimal`, `github`) or bring your own
- Built-in stylesheets (`default`, `minimal`, `academic`, `technical`, `blog`, `corporate`), a local CSS file, or a remote URL
- Responsive design with dark/light support
- Automatic table of contents
- Converts whole directories (preserving structure) or a single file
- Auto-copies asset folders (`media`, `images`, `assets`, `static`, `files`)
- Rewrites internal `.md` links to `.html`
- Generates `index.html` from `README.md` in directory mode
- Open Graph meta tags for social sharing

## Live demos

**[View the demo gallery](https://cameronbrooks11.github.io/md2html-action/demos/)** — the same Markdown rendered with each built-in theme:

- [Default](https://cameronbrooks11.github.io/md2html-action/demos/default/) — responsive layout with nav header and TOC, dark/light aware
- [Minimal](https://cameronbrooks11.github.io/md2html-action/demos/minimal/) — lightweight, content-focused
- [Academic](https://cameronbrooks11.github.io/md2html-action/demos/academic/) — serif typography for scholarly documents
- [Technical](https://cameronbrooks11.github.io/md2html-action/demos/technical/) — tech-docs styling with TOC and callouts
- [Blog](https://cameronbrooks11.github.io/md2html-action/demos/blog/) — article/blog layout
- [Corporate](https://cameronbrooks11.github.io/md2html-action/demos/corporate/) — business documentation styling
- [GitHub CSS](https://cameronbrooks11.github.io/md2html-action/demos/github/) — `github` template with remote [github-markdown-css](https://cdn.jsdelivr.net/npm/github-markdown-css@5.1.0/github-markdown.min.css)

## Usage

### Basic

```yaml
name: Build Documentation
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - name: Convert Markdown to HTML
        uses: CameronBrooks11/md2html-action@v1
        with:
          source-dir: "docs"
          output-dir: "website"
```

### Single file

```yaml
- name: Convert README to HTML
  uses: CameronBrooks11/md2html-action@v1
  with:
    source-file: "README.md"
    output-dir: "_site"
    template: "default"
```

In single-file mode the output is named after the input (`README.md` → `README.html`). For a Pages landing page at `index.html`, rename it after conversion, or use directory mode (which generates `index.html` from `README.md` automatically).

### Deploy to GitHub Pages

```yaml
name: Build and Deploy Docs
on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deploy.outputs.page_url }}
    steps:
      - uses: actions/checkout@v6

      - name: Convert Markdown to HTML
        id: convert
        uses: CameronBrooks11/md2html-action@v1
        with:
          source-dir: "docs"
          output-dir: "_site"
          site-title: "My Documentation"
          base-url: "https://USER.github.io/REPO"

      - uses: actions/upload-pages-artifact@v3
        with:
          path: ${{ steps.convert.outputs.output-path }}

      - id: deploy
        uses: actions/deploy-pages@v4
```

## Inputs

| Input            | Description                                                 | Default         |
| ---------------- | ----------------------------------------------------------- | --------------- |
| `source-dir`     | Directory of Markdown files to convert                      | `source`        |
| `source-file`    | Single Markdown file to convert (alternative to source-dir) | ``              |
| `output-dir`     | Directory where HTML files are generated                    | `_website`      |
| `template`       | `default`, `minimal`, `github`, or a path to a template     | `default`       |
| `stylesheet`     | Built-in name, a local CSS path, or a remote URL            | `default`       |
| `site-title`     | Site title (navigation and meta tags)                       | `Documentation` |
| `base-url`       | Base URL for the site (useful for GitHub Pages)             | ``              |
| `include-toc`    | Include a table of contents                                 | `true`          |
| `pandoc-options` | Additional Pandoc command-line options                      | ``              |

## Outputs

| Output            | Description                      |
| ----------------- | -------------------------------- |
| `output-path`     | Path to the generated HTML files |
| `files-converted` | Number of files converted        |

## Templates

- `default` — responsive layout with a navigation header and sidebar TOC
- `minimal` — minimal HTML scaffold
- `github` — pairs with `github-markdown-css` (set `stylesheet` to a GitHub CSS URL)
- a path such as `custom-template.html` — your own [Pandoc template](https://pandoc.org/MANUAL.html#templates)

## Stylesheets

Built-in options (all responsive, with dark/light support where noted):

- `default` — responsive theme with dark/light detection and a sidebar TOC
- `minimal` — lightweight, light-only
- `academic` — serif typography (Crimson Text, Libre Baskerville)
- `technical` — tech-docs styling with callouts and an interactive TOC
- `blog` — article/blog layout with display headings
- `corporate` — business documentation styling with a sticky TOC

You can also pass a local file (`assets/style.css`) or a remote URL (`https://.../style.css`).

```yaml
- uses: CameronBrooks11/md2html-action@v1
  with:
    source-dir: "docs"
    stylesheet: "technical"
```

## Automatic behavior

A few things happen automatically, without configuration:

- **Asset folders are copied.** Any `media`, `images`, `assets`, `static`, or `files` directory next to your source is copied into the output — relative to `source-dir` in directory mode, or relative to the source file in single-file mode — so relative image and asset links keep working.
- **Internal `.md` links are rewritten to `.html`.** A cross-page link written as `[other](other.md)` points to `other.html` in the generated site. Only `href` attributes are rewritten.
- **An `index.html` is generated from `README.md`** in directory mode, when the output does not already contain one.
- **Math is rendered with MathJax by default**, so `$E = mc^2$` works with no extra options.

## Markdown support

Standard Markdown plus tables, syntax-highlighted code blocks, footnotes, task lists, strikethrough, and math (MathJax). Frontmatter is optional; when present it can supply metadata:

```yaml
---
title: "Custom Page Title"
description: "Page description for SEO"
author: "Your Name"
navbar_home: true
---
# Your content here
```

## Custom templates

A template is an HTML file using Pandoc template variables. The most useful ones:

| Variable             | Description                       |
| -------------------- | --------------------------------- |
| `$title$`            | Page title                        |
| `$body$`             | Converted Markdown content        |
| `$table-of-contents$`| Table of contents (when enabled)  |
| `$site-title$`       | Site title from inputs            |
| `$rel_path$`         | Relative path to the site root    |
| `$stylesheet$`       | Local stylesheet path             |
| `$stylesheet-url$`   | Remote stylesheet URL             |
| `$base-url$`         | Base URL from inputs              |

See [`templates/default.html`](templates/default.html) for a complete example.

## Directory structure

```
your-repo/
├── docs/                  # Source Markdown
│   ├── index.md           # becomes index.html
│   ├── getting-started.md
│   ├── advanced/
│   │   └── configuration.md
│   └── media/             # images and other assets
└── .github/workflows/
    └── docs.yml           # your workflow
```

After conversion (`output-dir: _website`):

```
_website/
├── index.html
├── getting-started.html
├── advanced/
│   └── configuration.html
├── media/                 # copied assets
└── style.css              # stylesheet (for built-in/local stylesheets)
```

## Requirements

- Pandoc — installed automatically by the action
- Python 3 — pre-installed on GitHub-hosted runners; used for path utilities

## Local testing

Run the workflows locally with [act](https://github.com/nektos/act) (requires Docker):

```bash
gh extension install https://github.com/nektos/gh-act

# run a single integration job, binding outputs into the working directory
gh act -j test-default-configuration --bind

# run all integration tests
gh act -W .github/workflows/integration-tests.yml --bind
```

With `--bind`, generated HTML is written to the corresponding `outputs-*` directory; serve any of them to preview, e.g. `cd outputs-default-configuration && python -m http.server 8000`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). In short: fork, branch, commit, and open a pull request.

## License

MIT — see [LICENSE](LICENSE).

## Acknowledgments

Built with [Pandoc](https://pandoc.org/).
