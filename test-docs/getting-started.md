# Getting Started

This page demonstrates how to create documentation using Markdown.

## Prerequisites

- Basic knowledge of Markdown
- A GitHub repository
- The md2html-action configured

## Creating Your First Page

1. Create a `.md` file in your source directory
2. Start with a `# Title` heading
3. Write your content in standard Markdown
4. Push to trigger the action - that's it!

## Pure Markdown - No Setup Required

The action works with any standard Markdown file. Just write normal Markdown:

````markdown
# My Page Title

This is my content. No special formatting needed!

## Features

- Lists work
- **Bold** and _italic_ text
- [Links](https://example.com)
- Code blocks

```python
print("Hello, World!")
```
````

Want custom metadata? Frontmatter is optional:

```yaml
---
title: "Custom Page Title"
description: "SEO description"
author: "Your Name"
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

![Funny Frog Example](media/funny_frog.jpg)

## Next Steps

Once you're comfortable with the basics, check out [Advanced Configuration](advanced/configuration.md).
