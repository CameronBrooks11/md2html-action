# Advanced Configuration

This page covers advanced usage of the md2html-action.

## Custom Templates

You can create your own Pandoc templates:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>$title$</title>
  </head>
  <body>
    <main>$body$</main>
  </body>
</html>
```

## Template Variables

Key Pandoc template variables (automatically populated):

- `$title$` - Extracted from the first `# Heading` or filename
- `$body$` - Converted Markdown content
- `$toc$` - Table of contents (if enabled)
- `$date$` - Current date
- `$author$` - Can be set via action inputs

## Optional YAML Frontmatter

While the action works with vanilla Markdown, you can optionally add frontmatter for more control:

```yaml
---
title: "Custom Page Title"
description: "Page description for metadata"
author: "Your Name"
---
```

But this is **completely optional** - plain Markdown files work perfectly!

## Custom Stylesheets

You can use:

1. **Local CSS files** from your repository
2. **Remote CSS** from CDNs
3. **Built-in themes** (default, minimal)

## Advanced Pandoc Options

The action supports additional Pandoc options:

```yaml
pandoc-options: "--highlight-style=github --toc-depth=4 --number-sections"
```

## Directory Structure

For complex sites, organize your content:

```txt
docs/
├── index.md
├── section-1/
│   ├── page-1.md
│   └── page-2.md
└── section-2/
    └── page-3.md
```

## GitHub Pages Integration

Deploy to GitHub Pages:

```yaml
- name: Deploy to GitHub Pages
  uses: actions/deploy-pages@v4
  with:
    path: ${{ steps.convert.outputs.output-path }}
```

## Tips and Best Practices

1. **Use vanilla Markdown** - No frontmatter required!
2. Start files with `# Title` for automatic title extraction
3. Organize media files in a dedicated directory
4. Test locally before pushing
5. Use meaningful filenames and directory structure
6. Include navigation in your templates
7. Frontmatter is optional - only add it if you need custom metadata
