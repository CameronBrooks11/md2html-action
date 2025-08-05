# Advanced Configuration

This comprehensive guide covers advanced usage of md2html-action, including custom templates, advanced Pandoc options, deployment strategies, and power-user features.

## 🏗️ Action Configuration

### Complete Workflow Example

Here's a full-featured workflow configuration:

```yaml
name: Advanced Markdown to HTML Conversion

on:
  push:
    branches: [main, develop]
    paths: ["docs/**/*.md", "guides/**/*.md"]
  pull_request:
    paths: ["docs/**/*.md"]
  workflow_dispatch: # Manual trigger

jobs:
  convert:
    runs-on: ubuntu-latest

    permissions:
      contents: read
      pages: write
      id-token: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Full history for git info

      - name: Convert Markdown with custom options
        uses: CameronBrooks11/md2html-action@main
        id: convert
        with:
          # Source and output configuration
          source-dir: "docs"
          output-dir: "dist"

          # Theme and template selection
          stylesheet: "technical" # academic, technical, blog, corporate, default, minimal
          template: "default" # default, minimal, github

          # Custom CSS (optional)
          custom-css: "assets/custom.css"

          # Pandoc options
          pandoc-options: >-
            --toc
            --toc-depth=3
            --number-sections
            --highlight-style=github
            --katex
            --filter=pandoc-crossref
            --metadata title="My Documentation"
            --metadata author="Your Name"

      - name: Upload Pages artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ${{ steps.convert.outputs.output-path }}

  deploy:
    needs: convert
    runs-on: ubuntu-latest

    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}

    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### Input Parameters Reference

| Parameter        | Type   | Default     | Description                                                               |
| ---------------- | ------ | ----------- | ------------------------------------------------------------------------- |
| `source-dir`     | string | `'.'`       | Directory containing Markdown files                                       |
| `output-dir`     | string | `'html'`    | Output directory for HTML files                                           |
| `stylesheet`     | string | `'default'` | Theme: `academic`, `technical`, `blog`, `corporate`, `default`, `minimal` |
| `template`       | string | `'default'` | Template: `default`, `minimal`, `github`                                  |
| `custom-css`     | string | `''`        | Path to custom CSS file (optional)                                        |
| `pandoc-options` | string | `''`        | Additional Pandoc command-line options                                    |

## 🎨 Custom Templates

### Creating Custom Pandoc Templates

You can create your own Pandoc templates for complete control over the HTML output:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$if(title)$$title$$else$Documentation$endif$</title>

    <!-- Favicon -->
    $if(favicon)$
    <link rel="icon" href="$favicon$" />
    $endif$

    <!-- Stylesheets -->
    $if(css)$ $for(css)$
    <link rel="stylesheet" href="$css$" />
    $endfor$ $endif$

    <!-- Meta tags -->
    $if(description)$
    <meta name="description" content="$description$" />
    $endif$ $if(author)$
    <meta name="author" content="$author$" />
    $endif$

    <!-- Math support -->
    $if(math)$ $math$ $endif$
  </head>
  <body>
    <!-- Header -->
    <header class="site-header">
      <div class="header-content">
        <div class="site-title">
          <h1>
            <a href="index.html"
              >$if(site-title)$$site-title$$else$$title$$endif$</a
            >
          </h1>
        </div>

        <!-- Navigation -->
        $if(navbar)$
        <nav class="site-nav">
          $if(navbar_home)$
          <a href="index.html" class="nav-link $if(navbar_home)$active$endif$"
            >Home</a
          >
          $endif$ $for(nav-links)$
          <a
            href="$nav-links.url$"
            class="nav-link $if(nav-links.active)$active$endif$"
            >$nav-links.title$</a
          >
          $endfor$
        </nav>
        $endif$
      </div>
    </header>

    <!-- Main content -->
    <main class="main-content">
      <!-- Page header -->
      $if(title)$
      <header class="page-header">
        <h1 class="page-title">$title$</h1>
        $if(subtitle)$
        <p class="page-subtitle">$subtitle$</p>
        $endif$ $if(author)$
        <p class="page-author">$for(author)$$author$$sep$, $endfor$</p>
        $endif$
      </header>
      $endif$

      <!-- Table of contents -->
      $if(toc)$
      <nav class="table-of-contents">
        <h2>Table of Contents</h2>
        $toc$
      </nav>
      $endif$

      <!-- Page content -->
      <div class="page-content">$body$</div>
    </main>

    <!-- Footer -->
    <footer class="site-footer">
      <div class="footer-content">
        <p>
          &copy; $if(date)$$date$$else$2024$endif$
          $if(author)$$author$$else$Documentation$endif$
        </p>
      </div>
    </footer>
  </body>
</html>
```

### Template Variables Reference

md2html-action automatically populates these Pandoc template variables:

#### Core Variables

- `$title$` - Extracted from first `# Heading` or filename
- `$body$` - Converted Markdown content
- `$toc$` - Table of contents (when enabled)
- `$date$` - Current date
- `$css$` - CSS file paths

#### Optional Variables (from frontmatter)

- `$subtitle$` - Page subtitle
- `$author$` - Author name(s)
- `$description$` - Page description
- `$site-title$` - Site title
- `$favicon$` - Favicon path
- `$navbar$` - Enable navigation
- `$nav-links$` - Navigation links array

## 📋 YAML Frontmatter Guide

While md2html-action works perfectly with vanilla Markdown, frontmatter gives you additional control:

### Basic Frontmatter

```yaml
---
title: "Advanced Configuration Guide"
subtitle: "Power-user features and customization"
author: "Your Name"
description: "Comprehensive guide to advanced md2html-action features"
date: "2024-01-15"
---
# Your content starts here...
```

### Advanced Frontmatter

```yaml
---
# Page metadata
title: "API Documentation"
subtitle: "RESTful API Reference"
author: ["John Doe", "Jane Smith"]
description: "Complete API documentation with examples"
date: "2024-01-15"

# Site configuration
site-title: "My Documentation Site"
favicon: "media/favicon.ico"

# Navigation
navbar: true
navbar_home: true
nav-links:
  - title: "Getting Started"
    url: "getting-started.html"
    active: false
  - title: "API Reference"
    url: "api/index.html"
    active: true
  - title: "Examples"
    url: "examples/index.html"
    active: false

# Styling
css: ["custom.css", "syntax-highlighting.css"]

# Features
toc: true
math: true
---
# API Documentation

Your content here...
```

## 🔧 Advanced Pandoc Options

### Mathematical Typesetting

```yaml
pandoc-options: >-
  --katex
  --metadata title="Mathematical Documentation"
```

Example usage:

```markdown
Inline math: $E = mc^2$

Block math:
$$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$
```

### Cross-References

```yaml
pandoc-options: >-
  --filter=pandoc-crossref
  --number-sections
```

Example usage:

```markdown
See [@fig:example] for details.

![Example diagram](diagram.png){#fig:example}
```

### Citation Support

```yaml
pandoc-options: >-
  --filter=pandoc-citeproc
  --bibliography=references.bib
  --csl=ieee.csl
```

### Advanced TOC Configuration

```yaml
pandoc-options: >-
  --toc
  --toc-depth=4
  --number-sections
  --section-divs
```

### Code Highlighting

```yaml
pandoc-options: >-
  --highlight-style=github
  --syntax-definition=custom.xml
```

Available highlighting styles:

- `github` (recommended)
- `pygments`
- `kate`
- `monochrome`
- `breezedark`
- `haddock`

## 🎯 Custom CSS Integration

### Using Custom Stylesheets

1. **Create your custom CSS file:**

```css
/* custom.css */
:root {
  --primary-color: #your-brand-color;
  --secondary-color: #your-secondary-color;
}

.page-title {
  color: var(--primary-color);
  border-bottom: 3px solid var(--secondary-color);
}

.custom-callout {
  background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
  border-left: 4px solid var(--primary-color);
  padding: 1rem 1.5rem;
  margin: 1.5rem 0;
  border-radius: 0 8px 8px 0;
}
```

2. **Reference in your workflow:**

```yaml
- uses: CameronBrooks11/md2html-action@main
  with:
    custom-css: "assets/custom.css"
```

### CSS Override Examples

```css
/* Override theme colors */
:root {
  --text_color: #2d3748;
  --heading_color: #1a202c;
  --link_color: #3182ce;
  --accent_color: #38b2ac;
}

/* Custom components */
.feature-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin: 2rem 0;
}

.feature-card {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

/* Mobile optimizations */
@media (max-width: 768px) {
  .feature-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
}
```

## 🌐 Deployment Strategies

### GitHub Pages Deployment

```yaml
name: Deploy Documentation

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    permissions:
      contents: read
      pages: write
      id-token: write

    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}

    steps:
      - uses: actions/checkout@v4

      - name: Convert Markdown to HTML
        uses: CameronBrooks11/md2html-action@main
        id: convert
        with:
          source-dir: "docs"
          output-dir: "public"
          stylesheet: "corporate"

      - name: Upload to Pages
        uses: actions/upload-pages-artifact@v3
        with:
          path: ${{ steps.convert.outputs.output-path }}

      - name: Deploy to Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### Multi-Environment Deployment

```yaml
name: Multi-Environment Deploy

on:
  push:
    branches: [main, develop]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        environment: [staging, production]
        include:
          - environment: staging
            branch: develop
            theme: minimal
            url: staging.example.com
          - environment: production
            branch: main
            theme: corporate
            url: docs.example.com

    if: github.ref == format('refs/heads/{0}', matrix.branch)

    steps:
      - uses: actions/checkout@v4

      - name: Convert with environment config
        uses: CameronBrooks11/md2html-action@main
        with:
          stylesheet: ${{ matrix.theme }}
          pandoc-options: >-
            --metadata title="${{ matrix.environment }} Documentation"
            --metadata environment="${{ matrix.environment }}"
```

### Custom Domain Setup

1. **Create CNAME file:**

```yaml
- name: Create CNAME
  run: echo "docs.yourdomain.com" > ${{ steps.convert.outputs.output-path }}/CNAME
```

2. **Configure DNS:**
   - Add CNAME record: `docs.yourdomain.com` → `yourusername.github.io`
   - Or A records for apex domain: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`

## 📊 Advanced Directory Structures

### Large Documentation Sites

```txt
docs/
├── index.md                    # Homepage
├── getting-started/
│   ├── index.md               # Section landing page
│   ├── installation.md
│   ├── quick-start.md
│   └── first-project.md
├── guides/
│   ├── index.md
│   ├── user-guide/
│   │   ├── index.md
│   │   ├── basic-usage.md
│   │   └── advanced-features.md
│   └── admin-guide/
│       ├── index.md
│       ├── configuration.md
│       └── troubleshooting.md
├── api/
│   ├── index.md
│   ├── authentication.md
│   ├── endpoints/
│   │   ├── users.md
│   │   ├── products.md
│   │   └── orders.md
│   └── examples/
│       ├── curl.md
│       ├── javascript.md
│       └── python.md
├── reference/
│   ├── index.md
│   ├── configuration.md
│   ├── cli-commands.md
│   └── glossary.md
└── assets/
    ├── images/
    ├── diagrams/
    └── downloads/
```

### Multi-Language Documentation

```txt
docs/
├── en/
│   ├── index.md
│   ├── getting-started.md
│   └── api/
├── es/
│   ├── index.md
│   ├── primeros-pasos.md
│   └── api/
├── fr/
│   ├── index.md
│   ├── commencer.md
│   └── api/
└── shared/
    ├── images/
    └── diagrams/
```

## 🔍 SEO and Metadata Optimization

### SEO-Friendly Frontmatter

```yaml
---
title: "Complete API Reference - MyApp Documentation"
description: "Comprehensive API documentation for MyApp with examples, authentication guides, and endpoint references."
author: "MyApp Team"
keywords: ["API", "REST", "documentation", "MyApp", "developer"]
og:title: "MyApp API Documentation"
og:description: "Everything developers need to integrate with MyApp's REST API"
og:image: "https://docs.myapp.com/images/api-preview.png"
og:url: "https://docs.myapp.com/api/"
twitter:card: "summary_large_image"
twitter:title: "MyApp API Documentation"
twitter:description: "REST API docs with examples and guides"
twitter:image: "https://docs.myapp.com/images/api-preview.png"
canonical: "https://docs.myapp.com/api/"
---
```

### Structured Data

Add structured data to your custom template:

```html
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "TechArticle",
    "headline": "$title$",
    "description": "$description$",
    "author": {
      "@type": "Person",
      "name": "$author$"
    },
    "datePublished": "$date$",
    "url": "$canonical$"
  }
</script>
```

## 🛠️ Development and Testing

### Local Development Setup

1. **Install Pandoc:**

```bash
# macOS
brew install pandoc

# Ubuntu/Debian
sudo apt-get install pandoc

# Windows
choco install pandoc
```

2. **Create test script:**

```bash
#!/bin/bash
# test-conversion.sh

# Convert with different themes
themes=("academic" "technical" "blog" "corporate" "default" "minimal")

for theme in "${themes[@]}"; do
    echo "Testing theme: $theme"
    mkdir -p "test-output/$theme"

    pandoc docs/index.md \
        --template="templates/default.html" \
        --css="stylesheets/$theme.css" \
        --toc \
        --standalone \
        --output="test-output/$theme/index.html"
done

echo "✅ All themes tested successfully!"
```

### Automated Testing

```yaml
name: Test Documentation Build

on:
  pull_request:
    paths: ["docs/**/*.md"]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        theme: [academic, technical, blog, corporate, default, minimal]

    steps:
      - uses: actions/checkout@v4

      - name: Test theme ${{ matrix.theme }}
        uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "docs"
          output-dir: "test-${{ matrix.theme }}"
          stylesheet: ${{ matrix.theme }}

      - name: Validate HTML
        run: |
          npm install -g html-validate
          html-validate "test-${{ matrix.theme }}/**/*.html"

      - name: Check links
        run: |
          npm install -g markdown-link-check
          find docs -name "*.md" -exec markdown-link-check {} \;
```

## 🎯 Performance Optimization

### Image Optimization

```yaml
- name: Optimize images
  run: |
    # Install optimization tools
    sudo apt-get install imagemagick webp

    # Convert and compress images
    find docs -name "*.jpg" -o -name "*.png" | while read img; do
      # Convert to WebP
      cwebp -q 80 "$img" -o "${img%.*}.webp"
      
      # Optimize originals
      convert "$img" -quality 85 -strip "$img"
    done
```

### CSS and JS Minification

```yaml
- name: Minify assets
  run: |
    npm install -g clean-css-cli uglify-js

    # Minify CSS
    find ${{ steps.convert.outputs.output-path }} -name "*.css" | while read css; do
      cleancss -o "$css" "$css"
    done

    # Minify JS (if any)
    find ${{ steps.convert.outputs.output-path }} -name "*.js" | while read js; do
      uglifyjs "$js" -o "$js"
    done
```

### Caching Strategy

```yaml
- name: Setup caching
  uses: actions/cache@v3
  with:
    path: |
      ~/.cache/pandoc
      node_modules
    key: ${{ runner.os }}-docs-${{ hashFiles('docs/**/*.md') }}
    restore-keys: |
      ${{ runner.os }}-docs-
```

## 🆘 Troubleshooting Guide

### Common Issues and Solutions

#### 1. Build Failures

**Issue:** Action fails with Pandoc errors  
**Solution:**

```yaml
- name: Debug Pandoc
  run: |
    pandoc --version
    pandoc --list-templates
    pandoc --list-highlight-languages
```

#### 2. Missing Styles

**Issue:** CSS not loading properly  
**Solution:**

- Verify stylesheet name matches available themes
- Check file paths in workflow
- Ensure custom CSS files exist in repository

#### 3. Broken Links

**Issue:** Internal links not working  
**Solution:**

```markdown
<!-- Use relative paths -->

[Good link](../getting-started.md)
[Bad link](/getting-started.md)

<!-- For generated HTML links -->

[HTML link](../getting-started.html)
```

#### 4. Math Not Rendering

**Issue:** LaTeX math not displaying  
**Solution:**

```yaml
pandoc-options: >-
  --katex
  --metadata math=true
```

#### 5. TOC Not Generating

**Issue:** Table of contents empty  
**Solution:**

- Ensure proper Markdown headers (`#`, `##`, `###`)
- Add `--toc` to pandoc-options
- Check template includes `$toc$` variable

### Debug Mode

Enable verbose logging:

```yaml
- name: Convert with debug
  uses: CameronBrooks11/md2html-action@main
  with:
    source-dir: "docs"
    pandoc-options: "--verbose"
  env:
    ACTIONS_STEP_DEBUG: true
```

### Validation Tools

```yaml
- name: Validate output
  run: |
    # Check HTML validity
    html5validator --root ${{ steps.convert.outputs.output-path }}

    # Check accessibility
    pa11y-ci --sitemap http://localhost:3000/sitemap.xml

    # Performance audit
    lighthouse-ci --collect.url=http://localhost:3000
```

---

## 🚀 Next Steps

You now have comprehensive knowledge of md2html-action's advanced features! Here are some next steps:

1. **🎨 Experiment with custom templates** - Create your own branded designs
2. **📊 Set up analytics** - Track documentation usage and performance
3. **🔧 Automate workflows** - Integrate with your development process
4. **📚 Explore examples** - Check out real-world implementations
5. **🤝 Contribute** - Help improve the action for everyone

For more examples and community contributions, visit the [GitHub repository](https://github.com/CameronBrooks11/md2html-action)!
