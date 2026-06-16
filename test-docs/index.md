# Welcome to md2html-action Documentation

This comprehensive documentation demonstrates the full capabilities of md2html-action, a powerful GitHub Action that converts Markdown files to beautiful, professional HTML with multiple themes and templates.

Explore our comprehensive documentation:

- **[Getting Started](getting-started.md)** - Learn the basics and start converting your first Markdown files
- **[Advanced Configuration](advanced/configuration.md)** - Discover advanced features, custom templates, and styling options
- **[Examples & Use Cases](examples.md)** - Real-world examples and implementation patterns
- **[Troubleshooting Guide](troubleshooting.md)** - Solve common issues and debug problems

## Quick Start

The md2html-action works with **pure vanilla Markdown** - no frontmatter or special setup required! Just write standard Markdown and let the action handle the rest.

## Features Being Tested

- [x] **Markdown to HTML conversion** - Full Pandoc integration
- [x] **Pure vanilla Markdown support** - No frontmatter needed!
- [x] **Table of contents generation** - Automatic navigation
- [x] **Code syntax highlighting** - Beautiful code blocks
- [x] **Math rendering** - LaTeX math via Pandoc
- [x] **Links and navigation** - Internal and external links
- [x] **Multiple templates** - Default, minimal, and GitHub themes
- [x] **6 Professional stylesheets** - Academic, technical, blog, corporate designs
- [x] **Responsive design** - Mobile-friendly layouts
- [x] **GitHub Actions CI/CD** - Automated testing and deployment
- [x] **Demo gallery** - Interactive theme showcase

## Code Example

Here's a comprehensive Python example showcasing syntax highlighting:

```python
import asyncio
from typing import List, Optional
from dataclasses import dataclass

@dataclass
class User:
    """Represents a user in the system."""
    name: str
    email: str
    age: Optional[int] = None

    def greet(self) -> str:
        """Generate a personalized greeting."""
        return f"Hello, {self.name}! Welcome to md2html-action."

async def process_users(users: List[User]) -> None:
    """Process a list of users asynchronously."""
    tasks = [user.greet() for user in users]
    results = await asyncio.gather(*tasks)

    for result in results:
        print(result)

# Example usage
if __name__ == "__main__":
    users = [
        User("Alice", "alice@example.com", 30),
        User("Bob", "bob@example.com"),
        User("Charlie", "charlie@example.com", 25)
    ]

    asyncio.run(process_users(users))
```

## Feature Status

| Feature                | Status     | Notes                          |
| ---------------------- | ---------- | ------------------------------ |
| Markdown Conversion    | Working | Full Pandoc integration        |
| Default Template       | Working | Clean, responsive layout       |
| Minimal Template       | Working | Lightweight styling            |
| GitHub Template        | Working | GitHub-like appearance         |
| Academic Stylesheet    | Working | Professional academic styling  |
| Technical Stylesheet   | Working | Modern tech company design     |
| Blog Stylesheet        | Working | Personal blog styling          |
| Corporate Stylesheet   | Working | Professional business design   |
| Table of Contents      | Working | Auto-generated navigation      |
| Code Highlighting      | Working | Syntax highlighting support    |
| Math Rendering         | Working | LaTeX math via Pandoc          |
| Responsive Design      | Working | Mobile-friendly layouts        |
| GitHub Actions CI/CD   | Working | Automated testing & deployment |
| Demo Gallery           | Working | Interactive theme showcase     |
| Custom CSS Integration | Working | External stylesheet support    |

## Available Themes

The md2html-action includes 6 professional stylesheet themes:

### Academic

Perfect for research papers, theses, and academic documentation. Features traditional typography, proper citations, and scholarly formatting.

### Technical

Modern tech company design inspired by Stripe, Notion, and Linear. Features Inter fonts, gradient accents, and clean layouts ideal for API docs and developer guides.

### Blog

Personal blog styling with comfortable reading typography, engaging layouts, and social media integration hooks.

### Corporate

Professional business design suitable for company documentation, reports, and formal communications. Clean, authoritative styling.

### Default

Clean, responsive layout that works well for general documentation. Balanced typography and neutral color scheme.

### Minimal

Lightweight styling focused on performance and readability. Perfect for simple documentation sites.

## Responsive Design Example

All themes are fully responsive. Try resizing your browser window to see how the layout adapts!

| Device Type    | Layout Features      | Key Benefits               |
| -------------- | -------------------- | -------------------------- |
| **Mobile**  | Single column layout | Easy thumb navigation      |
| **Tablet**  | Flexible grid system | Optimized touch targets    |
| **Desktop** | Full-width layouts   | Floating table of contents |

## Navigation

## � Documentation Navigation

Explore the complete documentation:

- **[Getting Started](getting-started.md)** - Learn the basics and start converting your first Markdown files
- **[Advanced Configuration](advanced/configuration.md)** - Discover advanced features, custom templates, and styling options
- **[Demo Gallery](https://cameronbrooks11.github.io/md2html-action/demos/)** - Interactive showcase of all available themes and templates

## Math Rendering Example

The action supports LaTeX math rendering via Pandoc for technical documentation:

### Inline Math

Einstein's famous equation: $E = mc^2$ demonstrates mass-energy equivalence.

### Block Math

The fundamental theorem of calculus:

$$
\frac{d}{dx}\left( \int_{a}^{x} f(t)\,dt\right) = f(x)
$$

Complex equations with matrices:

$$
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
\begin{bmatrix}
x \\
y
\end{bmatrix}
=
\begin{bmatrix}
ax + by \\
cx + dy
\end{bmatrix}
$$

## Blockquote Styling

> **Pro Tip:** The md2html-action is designed to work with pure vanilla Markdown.  
> You don't need any special setup, frontmatter, or configuration files.  
> Just write standard Markdown and the action handles everything else!
>
> This makes it perfect for documentation that needs to be readable both as  
> Markdown source and as rendered HTML.

## Advanced Features

### Task Lists

- [x] Full Pandoc integration with all extensions
- [x] Six professional theme options
- [x] Responsive design for all devices
- [x] Automatic table of contents generation
- [x] Dark mode support (where applicable)
- [x] Beautiful table formatting
- [x] LaTeX math rendering
- [x] Smart link handling (internal/external)
- [ ] Multi-language support (planned)
- [ ] Plugin system (under development)

### Code Language Examples

**JavaScript/TypeScript:**

```typescript
interface User {
  id: number;
  name: string;
  email?: string;
}

const users: User[] = [
  { id: 1, name: "Alice", email: "alice@example.com" },
  { id: 2, name: "Bob" },
];

const activeUsers = users.filter((user) => user.email !== undefined);
```

**Bash/Shell:**

```bash
#!/bin/bash

# Install dependencies
npm install

# Run the md2html-action locally
npx @actions/core
pandoc --version

# Convert markdown to HTML
pandoc input.md -o output.html --template=template.html
```

**YAML Configuration:**

```yaml
name: Convert Markdown to HTML
on:
  push:
    paths: ["docs/**/*.md"]

jobs:
  convert:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: CameronBrooks11/md2html-action@v1
        with:
          source-dir: "docs"
          output-dir: "html"
          stylesheet: "technical"
```

## Performance & Compatibility

| Aspect              | Details                                                  |
| ------------------- | -------------------------------------------------------- |
| **Build Time**      | Fast conversion using optimized Pandoc                |
| **File Size**       | Minimal CSS/JS footprint                              |
| **Browser Support** | Modern browsers (Chrome 88+, Firefox 85+, Safari 14+) |
| **Mobile Support**  | Fully responsive on all devices                       |
| **Accessibility**   | WCAG 2.1 AA compliant                                 |
| **SEO Friendly**    | Semantic HTML with proper meta tags                   |

## Conclusion

If you can see this page properly formatted with:

- Professional typography and spacing
- Syntax-highlighted code blocks
- Responsive table layouts
- Mathematical equations
- Interactive table of contents
- Smooth navigation between pages

Then the md2html-action is working perfectly! 

Ready to get started? Check out the [Getting Started guide](getting-started.md) or dive into [Advanced Configuration](advanced/configuration.md) for power-user features.
