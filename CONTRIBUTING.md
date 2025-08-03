# Contributing to md2html-action

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/CameronBrooks11/md2html-action.git
   cd md2html-action
   ```

3. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Testing Your Changes

1. Make your changes to the action files
2. Test using the local action in a workflow:
   ```yaml
   - uses: ./  # This uses the local action
     with:
       source-dir: 'test-docs'
       output-dir: 'test-output'
   ```

3. Run the test workflow:
   ```bash
   # Push to trigger the test workflow
   git push origin feature/your-feature-name
   ```

## Adding New Templates

1. Create your template file in `templates/`:
   ```html
   <!-- templates/your-template.html -->
   <!DOCTYPE html>
   <!-- Your template content -->
   ```

2. Update the conversion script to recognize the new template
3. Add documentation to the README
4. Test with the new template

## Adding New Stylesheets

1. Create your stylesheet in `stylesheets/`:
   ```css
   /* stylesheets/your-theme.css */
   /* Your styles */
   ```

2. Update the conversion script to recognize the new stylesheet
3. Add documentation to the README
4. Test with the new stylesheet

## Code Style

- Use clear, descriptive variable names
- Add comments for complex logic
- Follow existing shell script style
- Test on multiple platforms (Linux, macOS, Windows)

## Submitting Changes

1. Ensure your changes work on all platforms
2. Update documentation if needed
3. Write clear commit messages
4. Submit a pull request with:
   - Clear description of changes
   - Link to any related issues
   - Screenshots if UI changes

## Release Process

Releases are automated when tags are pushed:

1. Update version in documentation
2. Create and push a tag:
   ```bash
   git tag -a v1.1.0 -m "Release v1.1.0"
   git push origin v1.1.0
   ```

## Getting Help

- Open an issue for bugs or feature requests
- Check existing issues before creating new ones
- Provide clear reproduction steps for bugs

Thank you for contributing! 🎉
