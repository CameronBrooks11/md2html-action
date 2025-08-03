---
title: "Getting Started"
description: "How to get started with this documentation system"
---

# Getting Started

This page demonstrates how to create documentation using Markdown.

## Prerequisites

- Basic knowledge of Markdown
- A GitHub repository
- The md2html-action configured

## Creating Your First Page

1. Create a `.md` file in your source directory
2. Add YAML frontmatter at the top
3. Write your content in Markdown
4. Push to trigger the action

## YAML Frontmatter

```yaml
---
title: "Page Title"
description: "SEO description"
author: "Your Name"
date: "2025-01-03"
---
```

## Markdown Syntax

### Headers

Use `#` for headers. The action will automatically generate a table of contents.

### Lists

- Unordered list item
- Another item
  - Nested item

1. Ordered list item
2. Another ordered item

### Links

- [Internal link](index.md)
- [External link](https://github.com)

### Images

You can include images from the media directory:

![Example](media/example.png)

## Next Steps

Once you're comfortable with the basics, check out [Advanced Configuration](advanced/configuration.md).
