#!/bin/bash

#
# build-for-appstore.sh
# GoMaster
#
# Complete build script for App Store submission
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="GoMaster"
SCHEME="GoMaster"
BUNDLE_ID="com.gomaster.app"
VERSION="1.0.0"
BUILD_NUMBER="1"

echo -e "${BLUE}════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    GoMaster - App Store Build Script              ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════${NC}"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Error: Xcode not found. Please install Xcode.${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Xcode found: $(xcodebuild -version | head -n1)"
echo ""

# Step 1: Clean build folder
echo -e "${YELLOW}[1/7]${NC} Cleaning build folder..."
rm -rf build/
mkdir -p build
echo -e "${GREEN}✓${NC} Build folder cleaned"
echo ""

# Step 2: Generate app icons
echo -e "${YELLOW}[2/7]${NC} Generating app icons..."
cd Assets
if [ -f "AppIcon-Generator.swift" ]; then
    mkdir -p AppIcons
    swift AppIcon-Generator.swift ./AppIcons
    echo -e "${GREEN}✓${NC} App icons generated"
else
    echo -e "${YELLOW}⚠${NC}  AppIcon-Generator.swift not found, skipping icon generation"
fi
cd ..
echo ""

# Step 3: Run Swift format (if available)
echo -e "${YELLOW}[3/7]${NC} Formatting code..."
if command -v swift-format &> /dev/null; then
    find . -name "*.swift" -not -path "./build/*" -exec swift-format format --in-place {} \;
    echo -e "${GREEN}✓${NC} Code formatted"
else
    echo -e "${YELLOW}⚠${NC}  swift-format not found, skipping formatting"
fi
echo ""

# Step 4: Validate project structure
echo -e "${YELLOW}[4/7]${NC} Validating project structure..."

required_files=(
    "GoMasterApp.swift"
    "Info.plist"
    "GoMaster.entitlements"
    "Models/GameModels.swift"
    "Game/GoGameEngine.swift"
    "Game/GoAIEngine.swift"
)

all_present=true
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗${NC} Missing: $file"
        all_present=false
    fi
done

if [ "$all_present" = true ]; then
    echo -e "${GREEN}✓${NC} All required files present"
else
    echo -e "${RED}❌ Error: Some required files are missing${NC}"
    exit 1
fi
echo ""

# Step 5: Build for testing
echo -e "${YELLOW}[5/7]${NC} Building for testing..."
xcodebuild clean build \
    -scheme "$SCHEME" \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -quiet

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Build successful"
else
    echo -e "${RED}❌ Error: Build failed${NC}"
    exit 1
fi
echo ""

# Step 6: Create archive
echo -e "${YELLOW}[6/7]${NC} Creating archive for App Store..."
echo -e "${BLUE}ℹ${NC}  This may take several minutes..."

ARCHIVE_PATH="./build/${PROJECT_NAME}.xcarchive"

xcodebuild archive \
    -scheme "$SCHEME" \
    -configuration Release \
    -archivePath "$ARCHIVE_PATH" \
    -destination 'generic/platform=iOS' \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    -quiet

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Archive created successfully"
    echo -e "${GREEN}  └─${NC} Location: $ARCHIVE_PATH"
else
    echo -e "${RED}❌ Error: Archive creation failed${NC}"
    exit 1
fi
echo ""

# Step 7: Summary and next steps
echo -e "${YELLOW}[7/7]${NC} Build summary"
echo ""
echo -e "${GREEN}✓ Build completed successfully!${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}              Next Steps                           ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""
echo "1. Open Xcode and configure code signing:"
echo "   • Select your development team"
echo "   • Verify bundle ID: $BUNDLE_ID"
echo "   • Enable automatic signing"
echo ""
echo "2. Create a new archive from Xcode:"
echo "   • Product → Archive"
echo "   • Wait for completion"
echo ""
echo "3. Distribute to App Store:"
echo "   • Window → Organizer"
echo "   • Select your archive"
echo "   • Click 'Distribute App'"
echo "   • Choose 'App Store Connect'"
echo "   • Follow the wizard"
echo ""
echo "4. Complete App Store metadata:"
echo "   • See: AppStore/AppStoreMetadata.md"
echo "   • Add screenshots"
echo "   • Add description"
echo "   • Submit for review"
echo ""
echo -e "${GREEN}Build artifacts are in: ./build/${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Good luck with your App Store submission! 🚀${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""

# Create a build info file
cat > build/BUILD_INFO.txt << EOF
GoMaster Build Information
═══════════════════════════════════════════════

Build Date: $(date)
Version: $VERSION
Build Number: $BUILD_NUMBER
Bundle ID: $BUNDLE_ID

Xcode Version: $(xcodebuild -version | head -n1)
macOS Version: $(sw_vers -productVersion)

Archive Path: $ARCHIVE_PATH

═══════════════════════════════════════════════

Ready for App Store submission!

Next steps:
1. Configure code signing in Xcode
2. Create archive (Product → Archive)
3. Distribute to App Store Connect
4. Complete metadata in App Store Connect
5. Submit for review

For detailed instructions, see README.md

═══════════════════════════════════════════════
EOF

echo -e "${GREEN}✓${NC} Build info saved to: build/BUILD_INFO.txt"
echo ""
