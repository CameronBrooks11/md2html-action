# 📚 Getting Started with md2html-action

Welcome to md2html-action! This guide will help you quickly start converting Markdown files to beautiful, styled HTML using this powerful GitHub Action.

## 🎯 What is md2html-action?

md2html-action is a GitHub Action that converts Markdown files to stunning HTML using Pandoc. It's designed to work with **pure vanilla Markdown** - no special setup, frontmatter, or configuration required!

### ✨ Key Features

- 🚀 **Zero Configuration** - Works with any standard Markdown file
- 🎨 **6 Professional Themes** - Academic, Technical, Blog, Corporate, Default, and Minimal
- 📱 **Fully Responsive** - Beautiful on desktop, tablet, and mobile
- 🔍 **Auto Table of Contents** - Generated automatically from your headings
- 🧮 **Math Support** - LaTeX math rendering via Pandoc
- ⚡ **Fast & Reliable** - Optimized for speed and performance

## 🛠️ Prerequisites

Before you begin, ensure you have:

- ✅ A GitHub repository
- ✅ Basic knowledge of Markdown syntax
- ✅ Basic understanding of GitHub Actions (helpful but not required)

## 🚀 Quick Setup

### Step 1: Create Your Workflow

Create `.github/workflows/convert-docs.yml` in your repository:

```yaml
name: Convert Markdown to HTML

on:
  push:
    paths: ["docs/**/*.md"]
  pull_request:
    paths: ["docs/**/*.md"]

jobs:
  convert:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Convert Markdown to HTML
        uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "docs" # Directory containing your .md files
          output-dir: "html" # Where to save the HTML files
          stylesheet: "technical" # Choose: default, minimal, academic, technical, blog, corporate
          template: "default" # Choose: default, minimal, github
```

### Step 2: Create Your First Markdown File

Create a `docs/` directory and add `docs/index.md`:

````markdown
# My Documentation

Welcome to my documentation site!

## Getting Started

This is a simple Markdown file that will be converted to beautiful HTML.

### Features

- Pure Markdown support
- No frontmatter required
- Automatic table of contents
- Responsive design

## Code Examples

Here's some Python code:

\```python
def hello_world():
print("Hello from md2html-action!")
\```

## Links

- [GitHub Repository](https://github.com/your-username/your-repo)
- [Documentation](https://your-username.github.io/your-repo/)
````

### Step 3: Push and Watch the Magic

1. Commit and push your changes:

   ```bash
   git add .
   git commit -m "Add md2html-action documentation"
   git push
   ```

2. Check the Actions tab in your GitHub repository
3. Watch as your Markdown is converted to stunning HTML!

## 🎨 Choosing Your Theme

md2html-action includes 6 professional themes:

| Theme            | Best For                   | Description                                  |
| ---------------- | -------------------------- | -------------------------------------------- |
| **🎓 Academic**  | Research papers, theses    | Traditional typography, scholarly formatting |
| **💻 Technical** | API docs, developer guides | Modern tech company design with Inter fonts  |
| **📝 Blog**      | Personal blogs, articles   | Comfortable reading typography               |
| **🏢 Corporate** | Business docs, reports     | Professional, authoritative styling          |
| **🎨 Default**   | General documentation      | Clean, balanced design                       |
| **⚡ Minimal**   | Simple sites               | Lightweight, fast-loading                    |

To change themes, simply update the `stylesheet` parameter in your workflow:

```yaml
- uses: CameronBrooks11/md2html-action@main
  with:
    stylesheet: "academic" # Change this to any theme name
```

## 📝 Writing Effective Markdown

### Essential Markdown Syntax

md2html-action works with any standard Markdown file. Here are the key elements:

#### Headers and Navigation

```markdown
# Main Title (H1)

## Section (H2)

### Subsection (H3)

#### Details (H4)
```

**Pro Tip:** Headers automatically generate a table of contents!

#### Text Formatting

```markdown
**Bold text** for emphasis
_Italic text_ for subtle emphasis
`inline code` for technical terms
~~Strikethrough~~ for corrections
```

#### Lists and Tasks

```markdown
Unordered lists:

- First item
- Second item
  - Nested item
  - Another nested item

Ordered lists:

1. Step one
2. Step two
3. Step three

Task lists:

- [x] Completed task
- [ ] Pending task
- [ ] Future task
```

#### Links and Images

```markdown
[Link text](https://example.com)
[Internal link](other-page.md)
![Image alt text](path/to/image.jpg)
![Local image](media/example.jpg)
```

#### Code Blocks

Use triple backticks with language specification:

````markdown
```python
def example_function():
    """This is a Python function."""
    return "Hello, World!"
```

```javascript
const greeting = (name) => {
  return `Hello, ${name}!`;
};
```

```bash
# Shell commands
npm install
git commit -m "Update docs"
```
````

#### Tables

```markdown
| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| Data 1   | Data 2   | Data 3   |
| Row 2    | More     | Data     |
```

#### Blockquotes

```markdown
> This is a blockquote.
> It can span multiple lines.
>
> Perfect for highlighting important information!
```

## 🔧 Working with Pure Markdown

One of md2html-action's greatest strengths is its support for **pure vanilla Markdown**:

### ✅ What Works Out of the Box

````markdown
# My Documentation

This is a simple Markdown file that requires no special setup!

## Features

- Pure Markdown support
- No frontmatter required
- Automatic title extraction from `# Heading`
- Table of contents generation
- Responsive design

## Code Example

\```python
def hello():
print("No configuration needed!")
\```

## Links

- [Another page](getting-started.md)
- [External link](https://github.com)
````

### 🎛️ Optional Frontmatter

While not required, you can add frontmatter for more control:

```yaml
---
title: "Custom Page Title"
description: "SEO-friendly page description"
author: "Your Name"
date: "2024-01-01"
---
# Your Content Here

The frontmatter above is completely optional but gives you more control over metadata.
```

## 🌐 Organizing Your Documentation

### Recommended Directory Structure

```txt
your-repository/
├── docs/                    # Your Markdown files
│   ├── index.md            # Homepage
│   ├── getting-started.md  # Getting started guide
│   ├── api/                # API documentation
│   │   ├── index.md
│   │   └── endpoints.md
│   ├── guides/             # User guides
│   │   ├── installation.md
│   │   └── configuration.md
│   └── media/              # Images and assets
│       ├── logo.png
│       └── screenshots/
├── .github/
│   └── workflows/
│       └── docs.yml        # Your md2html-action workflow
└── README.md
```

### Navigation Best Practices

1. **Start with index.md** - This becomes your homepage
2. **Use clear, descriptive filenames** - `getting-started.md` not `start.md`
3. **Create logical hierarchies** - Group related content in folders
4. **Link between pages** - Use relative links like `[Guide](guides/installation.md)`
5. **Include a media folder** - Keep images organized

## 📱 Mobile-Friendly Tips

All themes are fully responsive, but you can optimize for mobile:

### Image Sizing

```markdown
![Responsive image](media/screenshot.jpg)

<!-- Images automatically scale to container width -->
```

### Table Formatting

```markdown
| Feature | Mobile        | Desktop      |
| ------- | ------------- | ------------ |
| Layout  | Single column | Multi-column |
| TOC     | Collapsible   | Sidebar      |
```

### Content Structure

- Use shorter paragraphs on mobile
- Break up long sections with subheadings
- Include plenty of whitespace

## ⚡ Performance Tips

1. **Optimize Images** - Use compressed images (WebP, optimized JPG/PNG)
2. **Choose the Right Theme** - Minimal theme loads fastest
3. **Organize Content** - Split very long pages into multiple files
4. **Use Proper Headings** - Creates better TOC structure

## 🎯 Next Steps

Now that you understand the basics:

1. **[📖 Read the Advanced Configuration Guide](advanced/configuration.md)** - Learn about custom templates, advanced Pandoc options, and deployment strategies

2. **🎨 Explore the Demo Gallery** - See all themes in action at the demo gallery

3. **🔧 Customize Your Setup** - Experiment with different themes and templates

4. **📚 Check Real Examples** - Browse the source code of this documentation for reference

## 🆘 Troubleshooting

### Common Issues

**Problem:** Action not triggering  
**Solution:** Check your workflow file paths and ensure you're pushing to the correct branch

**Problem:** Styles not applying  
**Solution:** Verify the stylesheet name in your workflow matches available themes

**Problem:** Images not showing  
**Solution:** Use relative paths and ensure images are in your source directory

**Problem:** TOC not generating  
**Solution:** Make sure you're using proper Markdown headers (`#`, `##`, `###`)

### Getting Help

- **📋 Check the Issues** - Browse existing GitHub issues for solutions
- **💬 Start a Discussion** - Ask questions in GitHub Discussions
- **📖 Read the Source** - The action is open source and well-documented

---

Ready to dive deeper? Continue to [Advanced Configuration](advanced/configuration.md) for power-user features!
