# 🔧 Troubleshooting Guide

Having issues with md2html-action? This comprehensive troubleshooting guide will help you diagnose and fix common problems quickly.

## 🚨 Common Issues

### Build Failures

#### Issue: Action fails to run

**Symptoms:**

- Workflow doesn't trigger
- Action step shows "skipped"
- No HTML output generated

**Solutions:**

1. **Check file paths in workflow:**

   ```yaml
   on:
     push:
       paths: ["docs/**/*.md"] # Make sure this matches your structure
   ```

2. **Verify branch configuration:**

   ```yaml
   on:
     push:
       branches: [main] # Ensure you're pushing to the right branch
   ```

3. **Check repository permissions:**
   - Ensure Actions are enabled in repository settings
   - Verify workflow has necessary permissions

#### Issue: Pandoc conversion errors

**Symptoms:**

- Action runs but fails during conversion
- Error messages about invalid Markdown
- HTML files not generated

**Solutions:**

1. **Validate your Markdown:**

   ```bash
   # Test locally with Pandoc
   pandoc your-file.md -o test.html
   ```

2. **Check for unsupported syntax:**

   - Remove HTML comments in Markdown
   - Fix unclosed code blocks
   - Check for invalid frontmatter

3. **Enable debug mode:**
   ```yaml
   - uses: CameronBrooks11/md2html-action@main
     with:
       pandoc-options: "--verbose"
     env:
       ACTIONS_STEP_DEBUG: true
   ```

### Styling Issues

#### Issue: CSS not loading

**Symptoms:**

- HTML generated but no styling
- Default browser styles only
- Theme not applied

**Solutions:**

1. **Verify stylesheet name:**

   ```yaml
   # Valid options: academic, technical, blog, corporate, default, minimal
   stylesheet: "technical" # Must be exact match
   ```

2. **Check custom CSS path:**

   ```yaml
   custom-css: "assets/styles.css" # File must exist in repository
   ```

3. **Test with default theme:**
   ```yaml
   stylesheet: "default" # Always works as fallback
   ```

#### Issue: Broken layout

**Symptoms:**

- Content overlapping
- Missing navigation
- Table of contents not showing

**Solutions:**

1. **Verify template compatibility:**

   ```yaml
   template: "default" # Use default template for troubleshooting
   ```

2. **Check Markdown structure:**

   ```markdown
   # Main Title (required for proper structure)

   ## Section Headers (for TOC generation)

   Content here...
   ```

3. **Clear browser cache:**
   - Hard refresh (Ctrl+F5)
   - Clear cache and cookies
   - Test in incognito mode

### Content Issues

#### Issue: Table of contents not generating

**Symptoms:**

- TOC section empty
- No navigation links
- Headers not linked

**Solutions:**

1. **Enable TOC in Pandoc options:**

   ```yaml
   pandoc-options: "--toc --toc-depth=3"
   ```

2. **Use proper Markdown headers:**

   ```markdown
   # Level 1 Header

   ## Level 2 Header

   ### Level 3 Header
   ```

3. **Avoid HTML in headers:**

   ```markdown
   # Good Header

   # <span>Bad Header</span> # Don't do this
   ```

#### Issue: Math not rendering

**Symptoms:**

- LaTeX code showing as plain text
- Math formulas not formatted
- Equations display incorrectly

**Solutions:**

1. **Enable math support:**

   ```yaml
   pandoc-options: "--katex" # or --mathjax
   ```

2. **Use proper LaTeX syntax:**

   ```markdown
   Inline: $E = mc^2$

   Block:

   $$
   \int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
   $$
   ```

3. **Escape special characters:**

   ```markdown
   # In Markdown, escape backslashes

   $$\\alpha + \\beta = \\gamma$$
   ```

#### Issue: Links not working

**Symptoms:**

- 404 errors on internal links
- External links broken
- Navigation doesn't work

**Solutions:**

1. **Use relative paths:**

   ```markdown
   [Good](../other-page.md)
   [Bad](/absolute/path.md)
   ```

2. **Link to HTML files in output:**

   ```markdown
   # During development, link to .md

   [Development](other-page.md)

   # In production, Pandoc converts to .html

   [Production](other-page.html)
   ```

3. **Check file existence:**
   ```bash
   # Verify files exist in your repository
   find docs -name "*.md" -type f
   ```

### Image Issues

#### Issue: Images not displaying

**Symptoms:**

- Broken image icons
- Alt text showing instead of images
- 404 errors for image files

**Solutions:**

1. **Use relative paths:**

   ```markdown
   ![Good](media/image.jpg)
   ![Bad](/absolute/path/image.jpg)
   ```

2. **Verify image files exist:**

   ```bash
   ls -la docs/media/
   ```

3. **Check image formats:**

   ```markdown
   # Supported formats

   ![JPG](image.jpg)
   ![PNG](image.png)
   ![GIF](image.gif)
   ![WebP](image.webp)
   ```

4. **Add images to repository:**
   ```bash
   git add docs/media/
   git commit -m "Add images"
   git push
   ```

## 🐛 Debugging Techniques

### Enable Verbose Logging

```yaml
- name: Debug conversion
  uses: CameronBrooks11/md2html-action@main
  with:
    source-dir: "docs"
    pandoc-options: "--verbose"
  env:
    ACTIONS_STEP_DEBUG: true
    RUNNER_DEBUG: 1
```

### Test Locally

1. **Install Pandoc:**

   ```bash
   # macOS
   brew install pandoc

   # Ubuntu/Debian
   sudo apt-get install pandoc

   # Windows
   choco install pandoc
   ```

2. **Test conversion:**

   ```bash
   pandoc docs/index.md -o test.html --standalone --toc
   ```

3. **Test with specific template:**
   ```bash
   pandoc docs/index.md \
     --template=templates/default.html \
     --css=stylesheets/technical.css \
     --toc \
     --standalone \
     -o test.html
   ```

### Validate Content

1. **Check Markdown syntax:**

   ```bash
   # Install markdownlint
   npm install -g markdownlint-cli

   # Validate files
   markdownlint docs/**/*.md
   ```

2. **Validate HTML output:**

   ```bash
   # Install html5validator
   pip install html5validator

   # Validate generated HTML
   html5validator --root output/
   ```

3. **Check links:**

   ```bash
   # Install markdown-link-check
   npm install -g markdown-link-check

   # Check all markdown files
   find docs -name "*.md" -exec markdown-link-check {} \;
   ```

## 🔍 Performance Issues

### Slow Build Times

**Symptoms:**

- Workflow takes too long
- Action times out
- Build queue backs up

**Solutions:**

1. **Limit file processing:**

   ```yaml
   on:
     push:
       paths: ["docs/**/*.md"] # Only trigger on doc changes
   ```

2. **Use caching:**

   ```yaml
   - name: Cache Pandoc
     uses: actions/cache@v3
     with:
       path: ~/.cache/pandoc
       key: ${{ runner.os }}-pandoc-${{ hashFiles('docs/**/*.md') }}
   ```

3. **Optimize images:**
   ```bash
   # Compress images before committing
   find docs -name "*.jpg" -exec jpegoptim --max=85 {} \;
   find docs -name "*.png" -exec optipng -o2 {} \;
   ```

### Large Output Size

**Solutions:**

1. **Minimize CSS:**

   ```yaml
   - name: Minify CSS
     run: |
       npm install -g clean-css-cli
       find output -name "*.css" -exec cleancss -o {} {} \;
   ```

2. **Compress HTML:**
   ```yaml
   - name: Compress HTML
     run: |
       npm install -g html-minifier
       find output -name "*.html" -exec html-minifier --minify-css --minify-js -o {} {} \;
   ```

## 🛠️ Workflow Debugging

### Check Action Logs

1. **Go to Actions tab** in your GitHub repository
2. **Click on the failed workflow** run
3. **Expand the md2html-action step** to see detailed logs
4. **Look for error messages** in red text

### Common Log Messages

```bash
# File not found
Error: ENOENT: no such file or directory, open 'docs/missing.md'
Solution: Check file paths and ensure files exist

# Permission denied
Error: EACCES: permission denied
Solution: Check repository permissions and workflow settings

# Pandoc error
pandoc: Error reading docs/file.md
Solution: Check Markdown syntax and encoding

# Template error
pandoc: template error: variable title has no value
Solution: Add title to frontmatter or use default template
```

### Manual Testing

```yaml
name: Debug Workflow

on:
  workflow_dispatch: # Manual trigger

jobs:
  debug:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: List files
        run: |
          echo "Repository contents:"
          find . -type f -name "*.md" | head -20

      - name: Check Pandoc
        run: |
          pandoc --version
          pandoc --list-templates

      - name: Test conversion
        run: |
          if [ -f "docs/index.md" ]; then
            pandoc docs/index.md -o test.html --standalone
            echo "✅ Basic conversion successful"
          else
            echo "❌ docs/index.md not found"
          fi

      - name: Test with action
        uses: CameronBrooks11/md2html-action@main
        with:
          source-dir: "docs"
          output-dir: "debug-output"
          stylesheet: "default"
```

## 📱 Mobile and Browser Issues

### Mobile Display Problems

**Solutions:**

1. **Test responsive design:**

   ```html
   <!-- Add to custom template -->
   <meta name="viewport" content="width=device-width, initial-scale=1.0" />
   ```

2. **Check mobile-specific CSS:**
   ```css
   @media (max-width: 768px) {
     .table-of-contents {
       width: 100%;
       float: none;
     }
   }
   ```

### Browser Compatibility

1. **Test in multiple browsers:**

   - Chrome (latest)
   - Firefox (latest)
   - Safari (latest)
   - Edge (latest)

2. **Check for CSS features:**
   ```css
   /* Provide fallbacks for modern CSS */
   .gradient-text {
     color: #333; /* fallback */
     background: linear-gradient(45deg, #333, #666);
     -webkit-background-clip: text;
     background-clip: text;
   }
   ```

## 🆘 Getting Help

### Before Asking for Help

1. **Check this troubleshooting guide** thoroughly
2. **Search existing issues** on GitHub
3. **Test with minimal configuration** (default theme, simple Markdown)
4. **Gather relevant information:**
   - Workflow file content
   - Error messages from logs
   - Sample Markdown files
   - Expected vs actual output

### Where to Get Help

1. **GitHub Issues:**

   - Report bugs
   - Request features
   - Get technical support

2. **GitHub Discussions:**

   - Ask questions
   - Share configurations
   - Community support

3. **Documentation:**
   - [README](../README.md)
   - [Getting Started](getting-started.md)
   - [Advanced Configuration](advanced/configuration.md)

### Creating a Good Issue Report

````markdown
## Bug Report

**Describe the bug:**
Clear description of what's wrong

**To Reproduce:**

1. Step 1
2. Step 2
3. Error occurs

**Expected behavior:**
What should happen

**Workflow configuration:**

```yaml
# Your workflow file content
```
````

**Error logs:**

```
# Paste error messages here
```

**Environment:**

- OS: [e.g., Ubuntu 20.04]
- Pandoc version: [if known]
- Repository: [link if public]

**Additional context:**
Any other relevant information

````

## 🎯 Prevention Tips

### Best Practices

1. **Start simple:**
   - Use default theme initially
   - Test with basic Markdown
   - Add complexity gradually

2. **Version control everything:**
   - Commit templates and CSS
   - Track workflow changes
   - Use meaningful commit messages

3. **Test before deploying:**
   - Use pull request workflows
   - Test in staging environment
   - Validate output manually

4. **Monitor and maintain:**
   - Check build status regularly
   - Update dependencies
   - Review and update documentation

### Automation

```yaml
# Add automated checks
- name: Validate Markdown
  run: markdownlint docs/**/*.md

- name: Check links
  run: markdown-link-check docs/**/*.md

- name: Validate HTML
  run: html5validator output/**/*.html
````

---

## 📞 Quick Reference

| Problem            | Quick Fix                                 |
| ------------------ | ----------------------------------------- |
| Action not running | Check file paths in workflow triggers     |
| No styling         | Verify stylesheet name spelling           |
| TOC missing        | Add `--toc` to pandoc-options             |
| Math not rendering | Add `--katex` to pandoc-options           |
| Images broken      | Use relative paths, check file existence  |
| Links broken       | Use relative paths, link to `.html` files |
| Build timeout      | Optimize images, use caching              |
| HTML invalid       | Check Markdown syntax, use validators     |

Still having trouble? Don't hesitate to [open an issue](https://github.com/CameronBrooks11/md2html-action/issues) or start a [discussion](https://github.com/CameronBrooks11/md2html-action/discussions)!
