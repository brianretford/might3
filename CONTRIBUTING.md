# Contributing to Might3

Thank you for your interest in contributing to Might3! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/might3.git`
3. Create a feature branch: `git checkout -b feature/my-new-feature`
4. Follow the setup instructions in [SETUP.md](SETUP.md)

## Development Workflow

### Before Making Changes

1. Make sure all tests pass: `flutter test`
2. Ensure code is properly formatted: `dart format .`
3. Run the analyzer: `flutter analyze`

### Making Changes

1. Keep changes focused and atomic
2. Write tests for new functionality
3. Update documentation as needed
4. Follow the existing code style

### Code Style

- Use `dart format` for consistent formatting
- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Prefer `const` constructors where possible
- Use meaningful variable and function names
- Add comments for complex logic

### Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Ensure all tests pass before submitting PR
- Aim for good test coverage

### Commit Messages

Use clear, descriptive commit messages:

```
feat: Add priority levels to tasks
fix: Resolve widget sync issue on iOS
docs: Update setup instructions
refactor: Simplify Beads service implementation
test: Add tests for task sorting
```

Prefixes:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Test additions or changes
- `chore:` Build process or tooling changes

## Pull Request Process

1. Update the README.md with details of changes if applicable
2. Update the SETUP.md if you change dependencies or setup process
3. Ensure all tests pass and code is formatted
4. Submit your PR with a clear description of changes
5. Link any related issues

### PR Description Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe the tests you ran and how to reproduce

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally
```

## Areas for Contribution

### High Priority
- Authentication implementation (Supabase Auth)
- Real-time sync improvements
- Android widget support
- Web version optimization

### Features
- Task categories and tags
- Priority level UI
- Task reminders/notifications
- Themes and customization
- Dark/light mode improvements

### Documentation
- Video tutorials
- API documentation
- Architecture deep-dives
- Beads implementation guide

### Testing
- Increase test coverage
- Integration tests
- Performance tests
- Widget tests

## Beads Architecture Guidelines

When modifying the Beads service:

1. Maintain local-first approach
2. Keep the tree structure simple
3. Ensure offline functionality
4. Sync should be non-blocking
5. Handle sync conflicts gracefully

## Platform-Specific Guidelines

### macOS
- Test window transparency
- Verify always-on-top behavior
- Check system theme integration

### iOS
- Test widget updates
- Verify App Group data sharing
- Check widget refresh timing

## Questions?

- Open an issue for bugs or feature requests
- Use discussions for questions and ideas
- Check existing issues before creating new ones

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Follow the project's technical direction

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in the README and release notes.

Thank you for contributing to Might3! 🎯
