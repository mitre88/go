#!/bin/bash

#
# validate-project.sh
# GoMaster
#
# Validates project structure and readiness for App Store
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear

echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}║           ${MAGENTA}GoMaster Project Validator${CYAN}              ║${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

total_checks=0
passed_checks=0
warnings=0

# Function to check file existence
check_file() {
    total_checks=$((total_checks + 1))
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        passed_checks=$((passed_checks + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $2 ${RED}(MISSING: $1)${NC}"
        return 1
    fi
}

# Function to check directory existence
check_dir() {
    total_checks=$((total_checks + 1))
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        passed_checks=$((passed_checks + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $2 ${RED}(MISSING: $1)${NC}"
        return 1
    fi
}

# Function to check Swift syntax
check_swift_syntax() {
    if command -v swiftc &> /dev/null; then
        if swiftc -typecheck "$1" 2>/dev/null; then
            return 0
        else
            return 1
        fi
    fi
    return 0
}

# Section: Core Files
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[1/10] Core Application Files${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_file "GoMasterApp.swift" "App entry point"
check_file "Info.plist" "App configuration"
check_file "GoMaster.entitlements" "Entitlements"
echo ""

# Section: Models
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[2/10] Data Models${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_dir "Models" "Models directory"
check_file "Models/GameModels.swift" "Game models"
echo ""

# Section: Game Engine
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[3/10] Game Engine${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_dir "Game" "Game directory"
check_file "Game/GoGameEngine.swift" "Game logic engine"
check_file "Game/GoAIEngine.swift" "AI engine"
echo ""

# Section: Managers
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[4/10] Managers${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_dir "Managers" "Managers directory"
check_file "Managers/GameManager.swift" "Game manager"
check_file "Managers/AudioManager.swift" "Audio manager"
check_file "Managers/NotificationManager.swift" "Notification manager"
echo ""

# Section: Views
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[5/10] Views${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_dir "Views" "Views directory"
check_file "Views/IntroView.swift" "Intro view"
check_file "Views/ContentView.swift" "Content view (includes GameView)"
check_file "Views/GoBoardView.swift" "Board view"
check_file "Views/GameOverView.swift" "Game over view"
check_file "Views/ScoresView.swift" "Scores view"
check_file "Views/SettingsView.swift" "Settings view"
check_file "Views/NewGameSheet.swift" "New game sheet"
echo ""

# Section: Resources
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[6/10] Localization${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_dir "Resources" "Resources directory"
check_file "Resources/Localizable.strings" "Spanish localization"
check_file "Resources/Localizable-en.strings" "English localization"
echo ""

# Section: Assets
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[7/10] Assets${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_dir "Assets" "Assets directory"
check_file "Assets/AppIcon-Generator.swift" "Icon generator"
echo ""

# Section: App Store
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[8/10] App Store Materials${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_dir "AppStore" "AppStore directory"
check_file "AppStore/AppStoreMetadata.md" "App Store metadata"
echo ""

# Section: Documentation
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[9/10] Documentation${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_file "README.md" "Main documentation"
check_file "QUICKSTART.md" "Quick start guide"
check_file "IMPLEMENTATION_NOTES.md" "Implementation notes"
check_file "PROJECT_SUMMARY.md" "Project summary"
echo ""

# Section: Build Scripts
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}[10/10] Build Scripts${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
check_file "build-for-appstore.sh" "Build script"
if [ -x "build-for-appstore.sh" ]; then
    echo -e "${GREEN}✓${NC} Build script is executable"
    passed_checks=$((passed_checks + 1))
else
    echo -e "${YELLOW}⚠${NC}  Build script not executable (run: chmod +x build-for-appstore.sh)"
    warnings=$((warnings + 1))
fi
total_checks=$((total_checks + 1))
echo ""

# Additional Checks
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Additional Validation${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# Count Swift files
swift_count=$(find . -name "*.swift" -not -path "./build/*" -not -path "./.build/*" | wc -l | xargs)
echo -e "${CYAN}ℹ${NC}  Found ${YELLOW}$swift_count${NC} Swift files"

# Count lines of code
if command -v cloc &> /dev/null; then
    loc=$(cloc --quiet --include-lang=Swift . 2>/dev/null | grep Swift | awk '{print $5}')
    if [ ! -z "$loc" ]; then
        echo -e "${CYAN}ℹ${NC}  Total lines of code: ${YELLOW}$loc${NC}"
    fi
else
    loc=$(find . -name "*.swift" -not -path "./build/*" -exec wc -l {} + | tail -1 | awk '{print $1}')
    echo -e "${CYAN}ℹ${NC}  Estimated lines of code: ${YELLOW}~$loc${NC}"
fi

# Check for TODO/FIXME
todos=$(grep -r "TODO\|FIXME" --include="*.swift" . 2>/dev/null | wc -l | xargs)
if [ "$todos" -gt 0 ]; then
    echo -e "${YELLOW}⚠${NC}  Found ${YELLOW}$todos${NC} TODO/FIXME comments"
    warnings=$((warnings + 1))
else
    echo -e "${GREEN}✓${NC} No TODO/FIXME comments"
fi

# Check for force unwraps
force_unwraps=$(grep -r "!" --include="*.swift" . 2>/dev/null | grep -v "import\|//\|!=\|" | wc -l | xargs || echo "0")
if [ "$force_unwraps" -gt 10 ]; then
    echo -e "${YELLOW}⚠${NC}  Found ${YELLOW}$force_unwraps${NC} potential force unwraps"
    warnings=$((warnings + 1))
else
    echo -e "${GREEN}✓${NC} Minimal force unwraps detected"
fi

echo ""

# Swift version check
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Environment${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

if command -v swift &> /dev/null; then
    swift_version=$(swift --version | head -1)
    echo -e "${GREEN}✓${NC} Swift: ${CYAN}$swift_version${NC}"
else
    echo -e "${RED}✗${NC} Swift not found"
fi

if command -v xcodebuild &> /dev/null; then
    xcode_version=$(xcodebuild -version | head -1)
    echo -e "${GREEN}✓${NC} Xcode: ${CYAN}$xcode_version${NC}"
else
    echo -e "${YELLOW}⚠${NC}  Xcode not found (required for App Store build)"
    warnings=$((warnings + 1))
fi

echo ""

# Final Summary
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Validation Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

percentage=$((passed_checks * 100 / total_checks))

echo ""
echo -e "  Total Checks: ${CYAN}$total_checks${NC}"
echo -e "  Passed:       ${GREEN}$passed_checks${NC}"
echo -e "  Failed:       ${RED}$((total_checks - passed_checks))${NC}"
echo -e "  Warnings:     ${YELLOW}$warnings${NC}"
echo -e "  Success Rate: ${CYAN}$percentage%${NC}"
echo ""

if [ "$percentage" -eq 100 ] && [ "$warnings" -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                       ║${NC}"
    echo -e "${GREEN}║           ✓ PROJECT VALIDATION PASSED ✓              ║${NC}"
    echo -e "${GREEN}║                                                       ║${NC}"
    echo -e "${GREEN}║         🎉 Ready for App Store submission! 🎉        ║${NC}"
    echo -e "${GREEN}║                                                       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  1. Run: ${YELLOW}./build-for-appstore.sh${NC}"
    echo -e "  2. Open Xcode and configure signing"
    echo -e "  3. Create archive (Product → Archive)"
    echo -e "  4. Distribute to App Store Connect"
    echo ""
    exit 0
elif [ "$percentage" -ge 95 ]; then
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                                       ║${NC}"
    echo -e "${YELLOW}║         ⚠ PROJECT VALIDATION: WARNINGS ⚠             ║${NC}"
    echo -e "${YELLOW}║                                                       ║${NC}"
    echo -e "${YELLOW}║         Project is mostly complete but has           ║${NC}"
    echo -e "${YELLOW}║         minor issues that should be addressed.       ║${NC}"
    echo -e "${YELLOW}║                                                       ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    exit 1
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                       ║${NC}"
    echo -e "${RED}║          ✗ PROJECT VALIDATION FAILED ✗               ║${NC}"
    echo -e "${RED}║                                                       ║${NC}"
    echo -e "${RED}║         Critical files are missing.                  ║${NC}"
    echo -e "${RED}║         Please review the errors above.              ║${NC}"
    echo -e "${RED}║                                                       ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    exit 2
fi
