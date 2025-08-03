---
title: "Advanced Configuration"
description: "Advanced features and configuration options"
---

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

Key Pandoc template variables:

- `$title$` - Page title
- `$body$` - Converted content
- `$toc$` - Table of contents  
- `$date$` - Page date
- `$author$` - Page author

## Custom Stylesheets

You can use:

1. **Local CSS files** from your repository
2. **Remote CSS** from CDNs
3. **Built-in themes** (default, minimal)

## Advanced Pandoc Options

The action supports additional Pandoc options:

```yaml
pandoc-options: '--highlight-style=github --toc-depth=4 --number-sections'
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

1. Use consistent frontmatter across pages
2. Organize media files in a dedicated directory
3. Test locally before pushing
4. Use meaningful filenames and directory structure
5. Include navigation in your templates
