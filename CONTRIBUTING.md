# Contributing to ntfs-tool

First off, thank you for considering contributing to `ntfs-tool`! It's people like you that make open source such a fantastic environment for the developer community.

## Code of Conduct

By participating in this project, you agree to abide by our welcoming, respectful, and collaborative standard.

## How Can I Contribute?

### Reporting Bugs
- Ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/atilasevindi/ntfs-tool/issues).
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include:
  - macOS version (`sw_vers`) and processor architecture (`uname -m`).
  - Output of `ntfs-tool doctor`.
  - Terminal logs from `/tmp/ntfs3g_err.log` (if a mount fails).

### Suggesting Enhancements
Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:
- A clear and descriptive title.
- A step-by-step description of the suggested enhancement.
- Practical use case scenarios.

### Submitting Pull Requests
1. Fork the repository.
2. Create a topic branch from `main`: `git checkout -b feature/my-new-feature`.
3. Follow POSIX-compliant bash scripting standards. Test your script with `shellcheck` and `bash -n`.
4. Commit your changes with clear, descriptive commit messages.
5. Push to your fork and submit a Pull Request against `main`.

## Development Setup

```bash
git clone https://github.com/atilasevindi/ntfs-tool.git
cd ntfs-tool
chmod +x bin/ntfs-tool install.sh uninstall.sh
./bin/ntfs-tool doctor
```
