# 📝 Examples and Use Cases

This page showcases real-world examples of md2html-action in action, demonstrating various use cases, configurations, and best practices.

## 🏢 Corporate Documentation

Perfect for internal company docs, policies, and procedures.

### Example: Employee Handbook

```yaml
# .github/workflows/handbook.yml
name: Employee Handbook

on:
  push:
    paths: ["handbook/**/*.md"]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "handbook"
          output-dir: "employee-portal"
          stylesheet: "corporate"
          template: "default"
          pandoc-options: >-
            --toc
            --number-sections
            --metadata title="Employee Handbook"
            --metadata author="HR Department"
```

## 🎓 Academic Documentation

Ideal for research papers, theses, and academic publications.

### Example: Research Paper

```markdown
---
title: "Machine Learning Applications in Documentation"
subtitle: "A Comprehensive Analysis"
author: ["Dr. Jane Smith", "Prof. John Doe"]
institution: "University of Technology"
date: "2024-01-15"
abstract: |
  This paper explores the applications of machine learning
  in automated documentation generation and maintenance.
bibliography: references.bib
---

# Introduction

Academic writing requires precise formatting and citations [@smith2023].

## Literature Review

Previous work has shown that automated documentation tools
can significantly improve productivity [@doe2022; @johnson2023].

## References
```

## 💻 Technical Documentation

Perfect for API docs, developer guides, and technical specifications.

### Example: API Documentation

```yaml
# .github/workflows/api-docs.yml
name: API Documentation

on:
  push:
    paths: ["api-docs/**/*.md"]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "api-docs"
          output-dir: "public/api"
          stylesheet: "technical"
          template: "default"
          pandoc-options: >-
            --toc
            --highlight-style=github
            --metadata title="API Documentation"
```

Sample API documentation structure:

````markdown
# REST API Reference

## Authentication

All API requests require authentication via API key:

```bash
curl -H "Authorization: Bearer YOUR_API_KEY" \
     https://api.example.com/v1/users
```
````

## Endpoints

### Users

#### GET /users

Returns a list of users.

**Parameters:**

- `limit` (integer): Maximum number of results (default: 20)
- `offset` (integer): Number of results to skip (default: 0)

**Response:**

```json
{
  "users": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com"
    }
  ],
  "total": 150,
  "limit": 20,
  "offset": 0
}
```

## 📚 Educational Content

Great for course materials, tutorials, and learning resources.

### Example: Programming Course

```yaml
name: Programming Course Materials

on:
  push:
    paths: ["course/**/*.md"]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "course"
          output-dir: "course-site"
          stylesheet: "academic"
          template: "default"
          pandoc-options: >-
            --toc
            --number-sections
            --highlight-style=github
```

## 📖 Personal Blog

Ideal for personal websites, portfolios, and blog posts.

### Example: Personal Blog Setup

```yaml
name: Personal Blog

on:
  push:
    branches: [main]
    paths: ["blog/**/*.md"]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Convert blog posts
        uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "blog"
          output-dir: "public"
          stylesheet: "blog"
          template: "default"
          custom-css: "assets/custom-blog.css"
          pandoc-options: >-
            --metadata author="Your Name"
            --metadata site-title="My Blog"
```

### Blog Post Example

```markdown
---
title: "Getting Started with md2html-action"
date: "2024-01-15"
tags: ["documentation", "github-actions", "markdown"]
summary: "Learn how to convert Markdown to beautiful HTML with GitHub Actions"
---

# Getting Started with md2html-action

Converting Markdown to HTML has never been easier! In this post,
I'll walk you through setting up automated documentation generation.

## Why Use md2html-action?

- 🚀 **Zero configuration** - works with any Markdown
- 🎨 **Beautiful themes** - professional styling out of the box
- 📱 **Responsive design** - looks great on all devices

<!-- more -->

## Step-by-Step Setup

1. Create your workflow file
2. Add your Markdown content
3. Push and watch the magic happen!

![Screenshot](../media/example-output.png)

## Conclusion

With md2html-action, creating beautiful documentation is as simple
as writing Markdown. Give it a try in your next project!
```

## 🏗️ Multi-Site Architecture

Managing multiple documentation sites from a single repository.

### Example: Multi-Product Documentation

```yaml
name: Multi-Product Documentation

on:
  push:
    paths: ["docs/**/*.md"]

jobs:
  build-product-a:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "docs/product-a"
          output-dir: "dist/product-a"
          stylesheet: "technical"
          pandoc-options: >-
            --metadata title="Product A Documentation"

  build-product-b:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "docs/product-b"
          output-dir: "dist/product-b"
          stylesheet: "corporate"
          pandoc-options: >-
            --metadata title="Product B Documentation"
```

## 🌍 Internationalization

Supporting multiple languages in your documentation.

### Example: Multi-Language Setup

```yaml
name: Multi-Language Documentation

on:
  push:
    paths: ["docs/**/*.md"]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        language: [en, es, fr, de]
        include:
          - language: en
            title: "Documentation"
            source: docs/en
          - language: es
            title: "Documentación"
            source: docs/es
          - language: fr
            title: "Documentation"
            source: docs/fr
          - language: de
            title: "Dokumentation"
            source: docs/de

    steps:
      - uses: actions/checkout@v4
      - uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: ${{ matrix.source }}
          output-dir: "public/${{ matrix.language }}"
          stylesheet: "default"
          pandoc-options: >-
            --metadata title="${{ matrix.title }}"
            --metadata lang="${{ matrix.language }}"
```

## 🧪 A/B Testing Themes

Testing different themes for the same content.

### Example: Theme Comparison

```yaml
name: Theme A/B Testing

on:
  push:
    paths: ["docs/**/*.md"]

jobs:
  build-themes:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        theme: [academic, technical, blog, corporate, default, minimal]

    steps:
      - uses: actions/checkout@v4
      - uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "docs"
          output-dir: "test-themes/${{ matrix.theme }}"
          stylesheet: ${{ matrix.theme }}

      - name: Deploy theme test
        run: |
          echo "Theme ${{ matrix.theme }} deployed to:"
          echo "https://your-site.github.io/test-themes/${{ matrix.theme }}/"
```

## 📊 Analytics Integration

Adding analytics to track documentation usage.

### Example: Google Analytics Integration

```html
<!-- In your custom template -->
<!-- Google Analytics -->
<script
  async
  src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"
></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag() {
    dataLayer.push(arguments);
  }
  gtag("js", new Date());
  gtag("config", "GA_MEASUREMENT_ID");
</script>
```

## 🔍 Search Integration

Adding search functionality to your documentation.

### Example: Algolia Search Setup

```yaml
- name: Generate search index
  run: |
    # Install algolia CLI
    npm install -g atomic-algolia

    # Extract content for indexing
    find ${{ steps.convert.outputs.output-path }} -name "*.html" \
      -exec grep -l "class=\"page-content\"" {} \; | \
      while read file; do
        # Extract text content and create search index
        cat "$file" | grep -A 1000 'class="page-content"' | \
          grep -B 1000 '</div>' | \
          sed 's/<[^>]*>//g' >> search-index.txt
      done

    # Upload to Algolia
    atomic-algolia --source search-index.txt
```

## 🚀 Performance Optimization

Optimizing build times and output performance.

### Example: Optimized Workflow

```yaml
name: Optimized Documentation Build

on:
  push:
    paths: ["docs/**/*.md"]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 1 # Shallow clone for speed

      - name: Cache Pandoc
        uses: actions/cache@v3
        with:
          path: ~/.cache/pandoc
          key: pandoc-${{ runner.os }}

      - name: Convert documentation
        uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "docs"
          output-dir: "public"
          stylesheet: "technical"

      - name: Optimize images
        run: |
          find public -name "*.png" -o -name "*.jpg" | \
            xargs -I {} sh -c 'convert "$1" -quality 85 "$1"' _ {}

      - name: Compress HTML
        run: |
          find public -name "*.html" | \
            xargs -I {} sh -c 'gzip -k "$1"' _ {}
```

## 🔄 Automated Content Updates

Keeping documentation in sync with code changes.

### Example: API Sync Workflow

```yaml
name: Sync API Documentation

on:
  push:
    paths: ["src/api/**/*.py"]

jobs:
  sync-docs:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Generate API docs
        run: |
          # Extract API documentation from code
          python scripts/extract-api-docs.py src/api/ > docs/api-reference.md

      - name: Convert to HTML
        uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "docs"
          output-dir: "public"
          stylesheet: "technical"

      - name: Commit updated docs
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add docs/api-reference.md
          git commit -m "Auto-update API documentation" || exit 0
          git push
```

## 🎨 Custom Theme Development

Creating your own theme from scratch.

### Example: Custom Brand Theme

```css
/* custom-brand.css */
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap");

:root {
  /* Brand colors */
  --brand-primary: #6366f1;
  --brand-secondary: #8b5cf6;
  --brand-accent: #06b6d4;

  /* Typography */
  --font-primary: "Roboto", sans-serif;

  /* Spacing */
  --spacing-unit: 1rem;
}

body {
  font-family: var(--font-primary);
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
}

.main-content {
  background: white;
  border-radius: 12px;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
  margin: 2rem;
  padding: 3rem;
}

.page-title {
  background: linear-gradient(
    135deg,
    var(--brand-primary),
    var(--brand-secondary)
  );
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.table-of-contents {
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  border: 1px solid var(--brand-primary);
  border-radius: 8px;
}
```

Usage:

```yaml
- uses: CameronBrooks11/md2html-action@main
  with:
    custom-css: "assets/custom-brand.css"
```

## 📝 Best Practices Summary

### Content Organization

- Use clear, descriptive filenames
- Organize content in logical hierarchies
- Include navigation between related pages
- Maintain consistent heading structures

### Performance

- Optimize images before committing
- Use appropriate themes for your use case
- Cache build dependencies
- Minimize custom CSS when possible

### Maintenance

- Set up automated link checking
- Use consistent frontmatter schemas
- Version control your templates
- Test across different themes

### Accessibility

- Use semantic HTML structure
- Provide alt text for images
- Ensure sufficient color contrast
- Test with screen readers

---

## 🎯 Next Steps

Ready to implement these examples in your own projects? Here's how:

1. **Choose your use case** from the examples above
2. **Copy the relevant workflow** configuration
3. **Adapt the content structure** to your needs
4. **Customize styling** if needed
5. **Test and iterate** until perfect

Visit the [GitHub repository](https://github.com/CameronBrooks11/md2html-action) for more examples and community contributions!
