#!/bin/bash

# Script to help verify all Swift files are in the Xcode project
# Run this from the Unseen directory

echo "Checking Swift files in project..."
echo ""

# List all Swift files
find Unseen -name "*.swift" -type f | sort

echo ""
echo "Total Swift files: $(find Unseen -name "*.swift" -type f | wc -l)"
echo ""
echo "If any files are missing from Xcode:"
echo "1. Right-click on 'Unseen' folder in Xcode Project Navigator"
echo "2. Select 'Add Files to Unseen...'"
echo "3. Navigate to the file and add it"
echo "4. Make sure 'Unseen' target is checked"
