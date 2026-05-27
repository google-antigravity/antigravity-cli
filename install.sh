#!/bin/bash
#
# Antigravity CLI - Unix Bootstrapper Script (Bash/Zsh/Fish)
#
# Downloads, staging-verifies, and installs the Antigravity CLI flat native build.
#

set -euo pipefail

# 1. Default Setup & Constants
DOWNLOAD_BASE_URL="https://antigravity-cli-auto-updater-974169037036.us-central1.run.app"
TARGET_DIR="$HOME/.local/bin"
CUSTOM_DIR=""

# Helper: Display usage instructions
show_usage() {
    echo "Usage: install.sh [options]"
    echo ""
    echo "Options:"
    echo "  -d, --dir <path>    Specify a custom directory to install the binary"
    echo "  -h, --help          Display this help menu"
    echo ""
}

# Parse Arguments
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--dir)
            if [ -z "${2:-}" ]; then
                echo "[ERROR] Missing path for --dir parameter" >&2
                exit 1
            fi
            CUSTOM_DIR="$2"
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "[ERROR] Unknown parameter: $1" >&2
            show_usage
            exit 1
            ;;
    esac
    shift
done

# Resolve dynamic installation target directory
if [ -n "$CUSTOM_DIR" ]; then
    TARGET_DIR="$CUSTOM_DIR"
fi

BINARY_PATH="$TARGET_DIR/agy"

# 2. STEP 1: Pre-existence & Dynamic Path Check
if [ -f "$BINARY_PATH" ]; then
    echo "Notice: 'agy' is already installed at $BINARY_PATH."
    echo "The Antigravity CLI automatically self-updates in the background during regular runs."
    echo ""
    echo "If you want to perform a fresh installation, delete the binary first:"
    echo "  rm \"$BINARY_PATH\""
    exit 0
fi

echo "⠋ Detecting system environment..."

# 3. Detect Platform
case "$(uname -s)" in
    Darwin) os="darwin" ;;
    Linux) os="linux" ;;
    *) echo "Fatal: Unsupported operating system: $(uname -s). Antigravity CLI currently supports 64-bit Windows, macOS, and Linux." >&2; exit 1 ;;
esac

case "$(uname -m)" in
    x86_64|amd64) arch="amd64" ;;
    arm64|aarch64) arch="arm64" ;;
    *) echo "Fatal: Unsupported architecture: $(uname -m). Antigravity CLI currently supports 64-bit Windows, macOS, and Linux." >&2; exit 1 ;;
esac

# musl libc detection on Linux
platform=""
if [ "$os" = "linux" ]; then
    if [ -f /lib/libc.musl-x86_64.so.1 ] || [ -f /lib/libc.musl-aarch64.so.1 ] || ldd /bin/ls 2>&1 | grep -q musl; then
        platform="linux_${arch}_musl"
    else
        platform="linux_${arch}"
    fi
else
    platform="${os}_${arch}"
fi

echo "✓ Platform detected: $platform"

# POSIX-compliant JSON parser (no jq or grep -o dependencies)
parse_json_key() {
    local payload="$1"
    local key="$2"
    echo "$payload" | sed -n 's/.*"'"$key"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'
}

# Check for local installer package files
LOCAL_MODE=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_MANIFEST="$SCRIPT_DIR/packages/manifests/$platform.json"

version=""
url=""
sha512=""
manifest_json=""

if [ -f "$LOCAL_MANIFEST" ]; then
    manifest_json=$(cat "$LOCAL_MANIFEST" 2>/dev/null || true)
    if [ -n "$manifest_json" ]; then
        version=$(parse_json_key "$manifest_json" "version")
        url=$(parse_json_key "$manifest_json" "url")
        sha512=$(parse_json_key "$manifest_json" "sha512")
        if [ -n "$url" ] && [ -n "$sha512" ]; then
            archive_filename=$(basename "$url")
            LOCAL_ARCHIVE="$SCRIPT_DIR/packages/binaries/$archive_filename"
            if [ -f "$LOCAL_ARCHIVE" ]; then
                LOCAL_MODE=true
                echo "✓ Local package files found for platform $platform. Installing offline..."
            fi
        fi
    fi
fi

if [ "$LOCAL_MODE" = false ]; then
    # 4. Manifest Query & JSON Parsing (POSIX-Compliant)
    echo "⠋ Querying release repository..."

    # Construct Platform JSON Manifest URL
    MANIFEST_URL="$DOWNLOAD_BASE_URL/manifests/$platform.json"

    DOWNLOADER=""
    if command -v curl >/dev/null 2>&1; then
        DOWNLOADER="curl"
    elif command -v wget >/dev/null 2>&1; then
        DOWNLOADER="wget"
    else
        echo "Fatal: Either curl or wget is required but neither is installed." >&2
        exit 1
    fi

    fetch_manifest() {
        if [ "$DOWNLOADER" = "curl" ]; then
            curl -fsSL "$1"
        else
            wget -q -O - "$1"
        fi
    }

    manifest_json=$(fetch_manifest "$MANIFEST_URL" 2>/dev/null || true)
    if [ -z "$manifest_json" ]; then
        echo "Fatal: Could not connect to the release server to download the manifest. Please check your internet connection or firewall settings." >&2
        exit 1
    fi

    version=$(parse_json_key "$manifest_json" "version")
    url=$(parse_json_key "$manifest_json" "url")
    sha512=$(parse_json_key "$manifest_json" "sha512")

    if [ -z "$url" ] || [ -z "$sha512" ]; then
        echo "Fatal: Failed to parse release manifest. The manifest may be corrupted or malformed." >&2
        exit 1
    fi
fi

echo "✓ Latest available version: $version"

# 5. Download & SHA512 Checksum Verification
STAGING_DIR="$HOME/.cache/antigravity/staging"
if ! mkdir -p "$STAGING_DIR" 2>/dev/null; then
    echo "Error: Failed to create staging directory at $STAGING_DIR. Please check your home directory write permissions." >&2
    exit 1
fi

is_tar_gz=false
case "$url" in
    *.tar.gz*) is_tar_gz=true ;;
esac

if [ "$is_tar_gz" = true ]; then
    staging_payload="$STAGING_DIR/agy.tar.gz"
    extracted_binary="$STAGING_DIR/antigravity"
else
    staging_payload="$STAGING_DIR/agy"
    extracted_binary="$staging_payload"
fi

# Robust cleanup trap to ensure staging files are reaped on any exit (success or failure)
cleanup() {
    rm -f "${staging_payload:-}" "${extracted_binary:-}" 2>/dev/null || true
}
trap cleanup EXIT

download_file() {
    local src="$1"
    local dst="$2"
    if [ "$DOWNLOADER" = "curl" ]; then
        curl -fsSL -o "$dst" "$src"
    else
        wget -q -O "$dst" "$src"
    fi
}

if [ "$LOCAL_MODE" = true ]; then
    echo "⠋ Staging local release package..."
    cp "$LOCAL_ARCHIVE" "$staging_payload"
else
    echo "⠋ Downloading release package..."
    if ! download_file "$url" "$staging_payload"; then
        echo "Fatal: Failed to download release package from $url. Please check your internet connection or firewall settings." >&2
        exit 1
    fi
fi

# Compute OS-Specific SHA512 Checksum
actual_hash=""
if [ "$os" = "darwin" ]; then
    actual_hash=$(shasum -a 512 "$staging_payload" | cut -d' ' -f1 || true)
else
    actual_hash=$(sha512sum "$staging_payload" | cut -d' ' -f1 || true)
fi

if [ "$actual_hash" != "$sha512" ]; then
    echo "Security Halt: The payload checksum does not match the manifest. The file may be corrupted or compromised. Installation aborted." >&2
    exit 1
fi
echo "✓ Release package checksum verified."

# 6. Direct Binary Extraction & Write Permission Validation
if ! mkdir -p "$TARGET_DIR" 2>/dev/null; then
    echo "Write Error: Permission denied when attempting to create $TARGET_DIR. Please re-run the installer using the '--dir' flag to specify a writable custom directory." >&2
    exit 1
fi

if [ "$is_tar_gz" = true ]; then
    echo "⠋ Extracting binary from archive..."
    if ! tar -xzf "$staging_payload" -C "$STAGING_DIR" antigravity 2>/dev/null; then
        echo "Extraction Error: Failed to extract binary from archive." >&2
        exit 1
    fi
else
    echo "⠋ Copying binary directly to destination..."
fi

if ! cp "$extracted_binary" "$BINARY_PATH" 2>/dev/null; then
    echo "Write Error: Permission denied when attempting to write binary to $BINARY_PATH. Please re-run the installer using the '--dir' flag to specify a writable custom directory." >&2
    exit 1
fi

# Ensure Executable Permission Bit (soft fallback if filesystem doesn't support chmod)
chmod +x "$BINARY_PATH" || echo "Warning: Could not set executable permission bit on $BINARY_PATH. You may need to ensure the partition supports execution." >&2

# Clear macOS Gatekeeper Quarantine attribute to prevent unidentified developer blocks
if [ "$os" = "darwin" ]; then
    xattr -d com.apple.quarantine "$BINARY_PATH" 2>/dev/null || true
fi

# 7. Native Setup Handoff (Go-Native Setup Trigger - POSIX /bin/sh Compliant)
echo "⠋ Configuring shell environment..."

if [ -n "$CUSTOM_DIR" ]; then
    # Run with custom directory and absorb non-fatal soft warning exits
    "$BINARY_PATH" install --dir "$CUSTOM_DIR" || true
else
    # Run standard configuration and absorb non-fatal soft warning exits
    "$BINARY_PATH" install || true
fi


