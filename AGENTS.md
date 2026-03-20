## Overview

This is a Homebrew third-party tap (`elohmeier/tap`) containing custom formula definitions. Formulae are installed via `brew install elohmeier/tap/<formula>`.

## Repository Structure

All formulae live in `Formula/`. Each `.rb` file defines one Homebrew formula class.

## Common Commands

```bash
# Install a formula from this tap
brew install elohmeier/tap/<formula>

# Test a formula (runs the test block)
brew test elohmeier/tap/<formula>

# Audit a formula for style/correctness issues
brew audit --strict --online Formula/<formula>.rb

# Lint Ruby style
brew style Formula/<formula>.rb

# Build from source
brew install --build-from-source elohmeier/tap/<formula>

# Fetch and verify checksums for a new URL
brew fetch --build-from-source Formula/<formula>.rb
```

## Formula Patterns Used

- **Prebuilt binaries with platform detection**: `ssh-to-age` uses `on_macos`/`on_linux` + `on_intel`/`on_arm` blocks to download platform-specific binaries with per-platform sha256 checksums.
- **Go source builds**: `jsonnet-language-server` uses `depends_on "go" => :build` with `std_go_args`.
- **Java wrapper scripts**: `tabula-java` builds a fat JAR with Maven and creates a shell wrapper in `bin/`.
- **Source builds with patches**: `w3m-image` applies Debian patches to upstream source.
- **Livecheck blocks**: Used to enable `brew livecheck` for automatic version tracking.

## Adding a New Formula

1. Create `Formula/<name>.rb` with a class inheriting from `Formula`.
2. Include `desc`, `homepage`, `url`, `sha256`, `license`, and a `test` block at minimum.
3. Run `brew audit --strict --new --online Formula/<name>.rb` to validate.
4. Run `brew install --build-from-source elohmeier/tap/<name>` and `brew test elohmeier/tap/<name>` to verify.

## Updating a Formula Version

1. Update `version` (or `url` if version is embedded in URL).
2. Update `sha256` checksums — use `brew fetch` or `shasum -a 256` on the new artifacts.
3. For multi-platform binaries, update all platform-specific sha256 values.
