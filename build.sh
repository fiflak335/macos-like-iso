#!/bin/bash
# build.sh - Convenience script for building the ISO

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/output"

echo "=========================================="
echo "  macOS-like Live ISO Builder"
echo "=========================================="
echo ""
echo "This will build a ~3GB Debian-based Live ISO"
echo "with macOS-inspired UI (Plank dock, Rofi launcher, WhiteSur theme)"
echo ""
echo "Requirements:"
echo "  - Docker Desktop (Windows/macOS) or Docker Engine (Linux)"
echo "  - ~15GB free disk space"
echo "  - 8GB+ RAM recommended"
echo "  - 30-60 minutes build time"
echo ""

# Check Docker
if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker not found. Please install Docker Desktop."
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker daemon not running. Start Docker Desktop."
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Build image
echo "Building Docker image..."
docker build -t macos-like-iso "$SCRIPT_DIR"

# Run build
echo ""
echo "Starting ISO build (this takes 30-60 minutes)..."
echo "Output will be in: $OUTPUT_DIR"
echo ""

docker run --rm \
    --cpus="${BUILD_CPUS:-4}" \
    --memory="${BUILD_MEMORY:-8g}" \
    -v "$OUTPUT_DIR:/build/output" \
    macos-like-iso

# Check result
echo ""
echo "=========================================="
echo "  Build Complete!"
echo "=========================================="
ls -lh "$OUTPUT_DIR"/*.iso 2>/dev/null || echo "ISO not found in output directory"
echo ""
echo "To use in VirtualBox:"
echo "  1. Create new VM: Linux → Debian (64-bit)"
echo "  2. Enable EFI in System settings"
echo "  3. Attach ISO to optical drive"
echo "  4. Boot and enjoy!"