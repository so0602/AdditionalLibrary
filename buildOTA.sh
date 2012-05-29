PRODUCT=$1
TARGET=$2
CONFIG=$3
OUTPUT_DIR=$4
SIGN_CER=$5
PROVISION_PATH=$6
PROVISION_ID=$7
TAG=$8
PREPROCESSOR=$9

#read -p "Input Product: " PRODUCT

echo "You Input Product($PRODUCT)."

#read -p "Input Target: " TARGET

echo "You Input Target($TARGET)."

#read -p "Input Configuration: " CONFIG

echo "You Input Configuration($CONFIG)."

#read -p "Input Output Dir: " OUTPUT_DIR

echo "You Input Output Dir($OUTPUT_DIR)."

#read -p "Input Sign Cer: " SIGN_CER

echo "You Input Sign Cer($SIGN_CER)."

#read -p "Input Provision Path: " PROVISION_PATH

echo "You Input Provision Path($PROVISION_PATH)."

#read -p "Input Provision ID: " PROVISION_ID

echo "You Input Provision ID($PROVISION_ID)."

#read -p "Input Tag: " TAG

echo "You Input Tag($TAG)."

#read -p "Input Preprocessor Macros: " PREPROCESSOR

echo "You Input Preprocessor Macros($PREPROCESSOR)."

RELEASE_DIR="/Users/freddyso/Desktop/iPhone/AIAEB/build/$CONFIG-iphoneos"
#VERSION="1_0_0"
#DATESTR=$(date +%Y%m%d%k%M)

if [ ! -d "$OUTPUT_DIR" ]; then
	mkdir "$OUTPUT_DIR"
fi

#xcodebuild clean -configuration $CONFIG

echo "Build Start."
echo $RELEASE_DIR
#/Developer/usr/bin/xcodebuild -scheme $TARGET - configuration $CONFIG CONFIGURATION_BUILD_DIR="$RELEASE_DIR" GCC_PREPROCESSOR_DEFINITIONS="$PREPROCESSOR" -sdk iphoneos clean build
#xcodebuild -target $TARGET - configuration $CONFIG CONFIGURATION_BUILD_DIR="$RELEASE_DIR" GCC_VERSION="com.apple.compilers.llvm.clang.1_0" GCC_PREPROCESSOR_DEFINITIONS="$PREPROCESSOR" -sdk iphoneos clean build
xcodebuild -target $TARGET - configuration $CONFIG CONFIGURATION_BUILD_DIR="$RELEASE_DIR" GCC_PREPROCESSOR_DEFINITIONS="$PREPROCESSOR" PROVISIONING_PROFILE="$PROVISION_ID" -sdk iphoneos clean build
echo "Build End."

echo "-v $RELEASE_DIR/$PRODUCT.app"
echo "-o $OUTPUT_DIR/$TARGET-$TAG-$CONFIG.ipa"
echo "--sign $SIGN_CER"
echo "--embed ${PROVISION_PATH}/${PROVISION_ID}.mobileprovision"

xcrun -sdk iphoneos PackageApplication -v "$RELEASE_DIR/$PRODUCT.app" -o "$OUTPUT_DIR/$TARGET-$TAG-$CONFIG.ipa" --sign "$SIGN_CER" --embed "${PROVISION_PATH}/${PROVISION_ID}.mobileprovision"
cd "$OUTPUT_DIR/"
find . -name "$OUTPUT_DIR/$TARGET-$CONFIG.ipa" -exec rm -rf {} \;
cp "$OUTPUT_DIR/$TARGET-$TAG-$CONFIG.ipa" "$OUTPUT_DIR/$TARGET-$CONFIG.ipa"
echo "Export Ipa."

open "$OUTPUT_DIR"

exit


#Example
#PRODUCT="AIAEB"
#TARGET="AIAEB"
#CONFIG="UAT"
#OUTPUT="/Users/freddyso/Desktop/Builds/IPA/AIAEB"
#SIGN_CER="iPhone Developer: Daisy Ip (25Q6GBKR97)"
#PROVISION_PATH="/Users/freddyso/Library/MobileDevice/Provisioning Profiles"
#PROVISION_ID="CF39B28F-3544-4777-B374-B79D9F886DC6"
#DATESTR=$(date +%Y%m%d%k%M)
#PREPROCESSOR="UAT"

#Build AIAEB UAT Version
#sh buildOTA.sh "$PRODUCT" "$TARGET" "$CONFIG" "$OUTPUT" "$SIGN_CER" "$PROVISION_PATH" "$PROVISION_ID" "$DATESTR" "$PREPROCESSOR"