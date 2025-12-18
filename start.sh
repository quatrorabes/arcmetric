#!/bin/bash
# ============================================================================
# ArcMetric Quick Start - Fixed Path Issue
# ============================================================================

cd /Users/chrisrabenold/projects/arcmetric

echo "📂 Current directory: $(pwd)"
echo ""

# Check if we're in the right place
if [ ! -f "backend/requirements.txt" ]; then
    echo "❌ Error: backend/requirements.txt not found"
    echo "📍 Expected location: /Users/chrisrabenold/projects/arcmetric/backend/requirements.txt"
    echo ""
    echo "🔧 Fix: Make sure you're in the arcmetric directory"
    echo "   Run: cd /Users/chrisrabenold/projects/arcmetric"
    exit 1
fi

echo "✅ Files found!"
echo ""

# Now run dev.sh from the correct location
bash dev.sh
