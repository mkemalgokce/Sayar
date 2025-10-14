#!/bin/bash

# Setup Git Hooks for Sayar Project
# This script installs pre-commit hooks for automatic code formatting

set -e

echo "🔧 Setting up Git hooks..."

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "🎨 Running SwiftFormat..."
if command -v swiftformat &> /dev/null; then
    swiftformat .
    git add .
else
    echo "⚠️  SwiftFormat not found. Install it with: brew install swiftformat"
    exit 1
fi

echo "🧹 Running SwiftLint auto-fix..."
if command -v swiftlint &> /dev/null; then
    swiftlint --fix --quiet || true
    git add .
else
    echo "⚠️  SwiftLint not found. Install it with: brew install swiftlint"
    exit 1
fi

echo "✅ Code formatted successfully!"
EOF

# Make pre-commit hook executable
chmod +x .git/hooks/pre-commit

echo "✅ Git hooks installed successfully!"
echo ""
echo "📋 Make sure you have the required tools installed:"
echo "   brew install swiftformat"
echo "   brew install swiftlint"
