# Contributing to Vulkanize

Thank you for your interest in contributing to Vulkanize! We welcome contributions from everyone.

## Code of Conduct

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms. Please be respectful and considerate of others.

## How to Contribute

### Reporting Bugs

If you've found a bug, please create an issue on our [GitHub Issues](https://github.com/jatinkrmalik/vulkanize/issues) page with the following information:

- A clear, descriptive title
- A detailed description of the issue
- Steps to reproduce the problem
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Your device model and operating system
- Any additional context

### Suggesting Enhancements

We welcome suggestions for improvements! When creating an enhancement suggestion, please include:

- A clear, descriptive title
- A detailed description of the proposed enhancement
- The motivation behind the suggestion
- How it benefits users
- Any implementation details you can provide

### Pull Requests

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes thoroughly
5. Commit your changes (`git commit -m 'Add some amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Pull Request Guidelines

- Keep your changes focused. If you're fixing a bug, focus on that bug.
- Follow the existing code style.
- Write clear, descriptive commit messages.
- Include tests when adding new features.
- Update documentation if necessary.
- Ensure all tests pass before submitting.

## Development Environment Setup

### Prerequisites

- Git
- ADB (Android Debug Bridge)
- Basic knowledge of shell scripting (Bash/Batch)

### Setting Up

1. Clone the repository:
   ```bash
   git clone https://github.com/jatinkrmalik/vulkanize.git
   cd vulkanize
   ```

2. Make the scripts executable (Unix-based systems):
   ```bash
   chmod +x scripts/mac/vulkan-enabler.sh
   chmod +x scripts/linux/vulkan-enabler.sh
   ```

3. Test your changes:
   - Ensure scripts work on your platform
   - Test on other platforms if possible
   - Verify that the scripts handle errors gracefully

## Script Modification Guidelines

When modifying the scripts, please follow these guidelines:

1. **Cross-Platform Consistency**: Ensure that new features are implemented across all platforms (Windows, macOS, Linux) when applicable.

2. **Error Handling**: Include proper error handling and user-friendly error messages.

3. **Documentation**: Update comments within the code and relevant documentation files.

4. **Backward Compatibility**: Avoid breaking changes whenever possible.

5. **Keep It Simple**: Maintain the simplicity of the scripts while adding new features.

## Testing

Please test your changes thoroughly before submitting a pull request:

1. Test on your target platform.
2. Test with different device models (if available).
3. Test both the interactive and command-line modes.
4. Test error cases (e.g., no device connected, ADB not installed).

## Release Process

The project maintainers will handle the release process. If you're a maintainer, you can use the release automation script:

```bash
./scripts/release.sh 1.1.0
```

## Questions?

If you have any questions about contributing, please open an issue or contact the maintainers directly.

Thank you for your contributions!
