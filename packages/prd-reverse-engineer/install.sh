#!/bin/bash
#
# PRD Reverse Engineer — Installer
#
# Usage:
#   ./install.sh              # Install to current project (.claude/ in current dir)
#   ./install.sh /path/to/project  # Install to specified project
#

set -e

# Determine target project directory
if [ -n "$1" ]; then
    PROJECT_DIR="$1"
else
    PROJECT_DIR="$(pwd)"
fi

CLAUDE_DIR="$PROJECT_DIR/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================="
echo "  PRD Reverse Engineer — Installer"
echo "========================================="
echo ""
echo "Target project: $PROJECT_DIR"
echo ""

# Verify target is a valid project directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Directory '$PROJECT_DIR' does not exist."
    exit 1
fi

# Create target directories
mkdir -p "$CLAUDE_DIR/skills/prd"
mkdir -p "$CLAUDE_DIR/agents/prd"
mkdir -p "$CLAUDE_DIR/commands"

# Install skill
echo "[1/3] Installing skill..."
cp "$SCRIPT_DIR/skill/reverse-engineer.md" "$CLAUDE_DIR/skills/prd/"
echo "  -> .claude/skills/prd/reverse-engineer.md"

# Install agents
echo "[2/3] Installing agents..."
for f in "$SCRIPT_DIR/agents/"*.md; do
    filename=$(basename "$f")
    cp "$f" "$CLAUDE_DIR/agents/prd/$filename"
    echo "  -> .claude/agents/prd/$filename"
done

# Install commands
echo "[3/3] Installing commands..."
for f in "$SCRIPT_DIR/commands/"*.md; do
    filename=$(basename "$f")
    cp "$f" "$CLAUDE_DIR/commands/$filename"
    echo "  -> .claude/commands/$filename"
done

echo ""
echo "========================================="
echo "  Installation complete!"
echo "========================================="
echo ""
echo "Installed:"
echo "  - 1 skill (reverse-engineer.md)"
echo "  - 6 agents (analyzer, generator, reviewer, consolidator, updater, README)"
echo "  - 7 commands (/prd-analyze, /prd-generate, /prd-review, /prd-fix, /prd-consolidate, /prd-update, /prd-status)"
echo ""
echo "Prerequisites:"
echo "  1. Run mini-wiki skill first to generate .mini-wiki/wiki/"
echo "  2. Project should be a git repository (for /prd-update)"
echo ""
echo "Quick start:"
echo "  /prd-analyze       # Step 1: Generate plan"
echo "  /prd-generate      # Step 2: Generate PRDs"
echo "  /prd-review        # Step 3: Review quality"
echo "  /prd-fix           # Step 4: Fix issues"
echo "  /prd-consolidate   # Step 5: Generate overview"
echo "  /prd-update        # Ongoing: Update after code changes"
echo "  /prd-status        # Check progress"
