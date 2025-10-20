#!/bin/bash

echo "═══════════════════════════════════════════════════════"
echo "         GoMaster - Code Signing Setup Helper         "
echo "═══════════════════════════════════════════════════════"
echo ""

# Check if user has Apple Developer account
echo "Do you have an Apple Developer account? (yes/no)"
read -r has_account

if [ "$has_account" != "yes" ]; then
    echo ""
    echo "❌ You need an Apple Developer account to run on a physical device."
    echo ""
    echo "Options:"
    echo "1. Use the iOS Simulator (free) - Recommended for development"
    echo "2. Register for Apple Developer Program (\$99/year)"
    echo "   Visit: https://developer.apple.com/programs/"
    echo ""
    echo "For now, use the SIMULATOR:"
    echo "  - In Xcode, select 'iPhone 16 Pro' from device dropdown"
    echo "  - Press ⌘ + R to run"
    echo ""
    exit 0
fi

echo ""
echo "✅ Great! Let's configure code signing."
echo ""

# Get user's Apple ID
echo "Enter your Apple ID (email):"
read -r apple_id

# Get Bundle ID
echo ""
echo "Enter a unique Bundle Identifier:"
echo "  Format: com.yourname.gomaster"
echo "  Example: com.alexmitre.gomaster"
read -r bundle_id

# Get Team ID (optional)
echo ""
echo "Enter your Team ID (or press Enter to skip):"
echo "  Find it at: https://developer.apple.com/account"
read -r team_id

echo ""
echo "═══════════════════════════════════════════════════════"
echo "Configuration Summary:"
echo "═══════════════════════════════════════════════════════"
echo "Apple ID:     $apple_id"
echo "Bundle ID:    $bundle_id"
if [ ! -z "$team_id" ]; then
    echo "Team ID:      $team_id"
fi
echo ""

echo "Next steps:"
echo ""
echo "1. Open Xcode Settings (⌘ + ,)"
echo "   → Accounts"
echo "   → Add your Apple ID: $apple_id"
echo ""
echo "2. In your project:"
echo "   → Select 'GoMaster' target"
echo "   → Signing & Capabilities"
echo "   → Enable 'Automatically manage signing'"
echo "   → Select your Team"
echo "   → Change Bundle ID to: $bundle_id"
echo ""
echo "3. On your iPhone:"
echo "   → Settings → General → VPN & Device Management"
echo "   → Trust '$apple_id'"
echo ""
echo "4. In Xcode:"
echo "   → Select your physical device"
echo "   → Press ⌘ + Shift + K (Clean)"
echo "   → Press ⌘ + R (Run)"
echo ""
echo "═══════════════════════════════════════════════════════"
echo ""

# Create a configuration file
cat > signing-config.txt << INNER_EOF
GoMaster Code Signing Configuration
═══════════════════════════════════════════════════════

Apple ID: $apple_id
Bundle ID: $bundle_id
INNER_EOF

if [ ! -z "$team_id" ]; then
    echo "Team ID: $team_id" >> signing-config.txt
fi

echo "Configuration saved to: signing-config.txt"
echo ""
