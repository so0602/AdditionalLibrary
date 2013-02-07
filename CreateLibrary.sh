DEVICE=iphoneos
SIMULATOR=iphonesimulator

TARGET=YTLibrary
Folder=${TARGET}

FILE_NAME=libYT.a

sh AttributeList.sh

#xcodebuild -sdk $DEVICE "ARCHS=armv6 armv7" clean build -target $TARGET
#xcodebuild -sdk $SIMULATOR "ARCHS=i386 x86_64" "VALID_ARCHS=i386 x86_64" clean build -target $TARGET
xcodebuild -sdk $DEVICE "ARCHS=armv6 armv7" -target $TARGET
xcodebuild -sdk $SIMULATOR "ARCHS=i386 x86_64" "VALID_ARCHS=i386 x86_64" -target $TARGET

BUILD_PATH=${BUILD_DIR}
#Change Your Build Directory
#BUILD_PATH="/Users/DeViLsO/Desktop/iPhone/Builds"
#BUILD_PATH="/Users/freddyso/Desktop/iPhone/AdditionalLibrary/build"
BUILD_PATH="/Users/freddy_so/Documents/iOS/AdditionalLibrary/build"

RELEASE_DEVICE_DIR=${BUILD_PATH}/Release-iphoneos
RELEASE_SIMULATOR_DIR=${BUILD_PATH}/Release-iphonesimulator
STATICLIB=${BUILD_PATH}/_Library

if [ ! -e "$STATICLIB" ]; then
	mkdir "$STATICLIB"
fi

STATICLIB=${STATICLIB}/${Folder}

if [ ! -e "$STATICLIB" ]; then
	mkdir "$STATICLIB"
fi

lipo -output "${STATICLIB}/${FILE_NAME}" -create "${RELEASE_DEVICE_DIR}/${FILE_NAME}" "${RELEASE_SIMULATOR_DIR}/${FILE_NAME}"

rm "${RELEASE_DEVICE_DIR}/${FILE_NAME}"
rm "${RELEASE_SIMULATOR_DIR}/${FILE_NAME}"

#My Sources
YTHEADER_PATH=${STATICLIB}/YTHeader
if [ ! -e "$YTHEADER_PATH" ]; then
	mkdir "$YTHEADER_PATH"
fi
cp MySources/*.h "$YTHEADER_PATH"

#ADLivelyTableView
ADLIVELYTABLEVIEW_PATH=${STATICLIB}/ADLivelyTableView
if [ ! -e "$ADLIVELYTABLEVIEW_PATH" ]; then
mkdir "$ADLIVELYTABLEVIEW_PATH"
fi
cp ADLivelyTableView/*.h "$ADLIVELYTABLEVIEW_PATH"

#ASIHttpRequest
ASIHTTPREQUEST_PATH=${STATICLIB}/ASIHTTPRequest
if [ ! -e "$ASIHTTPREQUEST_PATH" ]; then
	mkdir "$ASIHTTPREQUEST_PATH"
fi
cp ASIHTTPRequest/*.h "$ASIHTTPREQUEST_PATH"

ASIHTTPREQUEST_ASIWEBPAGEREQUEST_PATH=${STATICLIB}/ASIHTTPRequest/ASIWebPageRequest
if [ ! -e "$ASIHTTPREQUEST_ASIWEBPAGEREQUEST_PATH" ]; then
	mkdir "$ASIHTTPREQUEST_ASIWEBPAGEREQUEST_PATH"
fi
cp ASIHTTPRequest/ASIWebPageRequest/*.h "$ASIHTTPREQUEST_ASIWEBPAGEREQUEST_PATH"

ASIHTTPREQUEST_S3_PATH=${STATICLIB}/ASIHTTPRequest/S3
if [ ! -e "$ASIHTTPREQUEST_S3_PATH" ]; then
	mkdir "$ASIHTTPREQUEST_S3_PATH"
fi
cp ASIHTTPRequest/S3/*.h "$ASIHTTPREQUEST_S3_PATH"

ASIHTTPREQUEST_CLOUDFILES_PATH=${STATICLIB}/ASIHTTPRequest/CloudFiles
if [ ! -e "$ASIHTTPREQUEST_CLOUDFILES_PATH" ]; then
	mkdir "$ASIHTTPREQUEST_CLOUDFILES_PATH"
fi
cp ASIHTTPRequest/CloudFiles/*.h "$ASIHTTPREQUEST_CLOUDFILES_PATH"

#ATMHud
ATMHUD_PATH=${STATICLIB}/ATMHud
if [ ! -e "$ATMHUD_PATH" ]; then
mkdir "$ATMHUD_PATH"
fi
cp ATMHud/*.h "$ATMHUD_PATH"
cp -R ATMHud/*.bundle "$ATMHUD_PATH"

#AudioStreamer
AUDIOSTREAMER_PATH=${STATICLIB}/AudioStreamer
if [ ! -e "$AUDIOSTREAMER_PATH" ]; then
	mkdir "$AUDIOSTREAMER_PATH"
fi
cp AudioStreamer/*.h "$AUDIOSTREAMER_PATH"

#CocoaAMF
COCOAAMF_PATH=${STATICLIB}/CocoaAMF
if [ ! -e "$COCOAAMF_PATH" ]; then
	mkdir "$COCOAAMF_PATH"
fi
cp CocoaAMF/*.h "$COCOAAMF_PATH"

#CocoaSecurity
COCOASECURITY_PATH=${STATICLIB}/CocoaSecurity
if [ ! -e "$COCOASECURITY_PATH" ]; then
	mkdir "$COCOASECURITY_PATH"
fi
cp CocoaSecurity/*.h "$COCOASECURITY_PATH"

COCOASECURITY_GTMBASE64_PATH=${COCOASECURITY_PATH}/GTMBase64
if [ ! -e "$COCOASECURITY_GTMBASE64_PATH" ]; then
	mkdir "$COCOASECURITY_GTMBASE64_PATH"
fi
cp CocoaSecurity/GTMBase64/*.h "$COCOASECURITY_GTMBASE64_PATH"

#CurledView
CURLEDVIEW_PATH=${STATICLIB}/CurledView
if [ ! -e "$CURLEDVIEW_PATH" ]; then
	mkdir "$CURLEDVIEW_PATH"
fi
cp CurledView/*.h "$CURLEDVIEW_PATH"

#DCRoundSwitch
DCROUNDSWITCH_PATH=${STATICLIB}/DCRoundSwitch
if [ ! -e "$DCROUNDSWITCH_PATH" ]; then
	mkdir "$DCROUNDSWITCH_PATH"
fi
cp DCRoundSwitch/*.h "$DCROUNDSWITCH_PATH"

#DejalActivityView
DEJALACTIVITYVIEW_PATH=${STATICLIB}/DejalActivityView
if [ ! -e "$DEJALACTIVITYVIEW_PATH" ]; then
mkdir "$DEJALACTIVITYVIEW_PATH"
fi
cp DejalActivityView/*.h "$DEJALACTIVITYVIEW_PATH"

#EGOPhotoViewer
EGOPHOTOVIEWER_PATH=${STATICLIB}/EGOPhotoViewer
if [ ! -e "$EGOPHOTOVIEWER_PATH" ]; then
	mkdir "$EGOPHOTOVIEWER_PATH"
fi
cp EGOPhotoViewer/*.h "$EGOPHOTOVIEWER_PATH"
cp -R EGOPhotoViewer/*.bundle "$EGOPHOTOVIEWER_PATH"

#FTUtils
FTUTILS_PATH=${STATICLIB}/FTUtils
if [ ! -e "$FTUTILS_PATH" ]; then
	mkdir "$FTUTILS_PATH"
fi
cp FTUtils/*.h "$FTUTILS_PATH"

#FMDatabase
FMDATABASE_PATH=${STATICLIB}/FMDatabase
if [ ! -e "$FMDATABASE_PATH" ]; then
mkdir "$FMDATABASE_PATH"
fi
cp FMDatabase/*.h "$FMDATABASE_PATH"

#GMGridView
GMGRIDVIEW_PATH=${STATICLIB}/GMGridView
if [ ! -e "$GMGRIDVIEW_PATH" ]; then
mkdir "$GMGRIDVIEW_PATH"
fi
cp GMGridView/*.h "$GMGRIDVIEW_PATH"

#HTMLParser
HTMLPARSER_PATH=${STATICLIB}/HTMLParser
if [ ! -e "$HTMLPARSER_PATH" ]; then
mkdir "$HTMLPARSER_PATH"
fi
cp HTMLParser/*.h "$HTMLPARSER_PATH"

#iCarousel
ICAROUSEL_PATH=${STATICLIB}/iCarousel
if [ ! -e "$ICAROUSEL_PATH" ]; then
	mkdir "$ICAROUSEL_PATH"
fi
cp iCarousel/*.h "$ICAROUSEL_PATH"

#ITNSStreamUtil
ITNSSTREAMUTIL_PATH=${STATICLIB}/ITNSStreamUtil
if [ ! -e "$ITNSSTREAMUTIL_PATH" ]; then
	mkdir "$ITNSSTREAMUTIL_PATH"
fi
cp ITNSStreamUtil/*.h "$ITNSSTREAMUTIL_PATH"

#JSONKit
JSONKIT_PATH=${STATICLIB}/JSONKit
if [ ! -e "$JSONKIT_PATH" ]; then
mkdir "$JSONKIT_PATH"
fi
cp JSONKit/*.h "$JSONKIT_PATH"

#KissXML
KISSXML_PATH=${STATICLIB}/KissXML
if [ ! -e "$KISSXML_PATH" ]; then
mkdir "$KISSXML_PATH"
fi
cp KissXML/*.h "$KISSXML_PATH"

KISSXML_ADDITIONS_PATH=${KISSXML_PATH}/Additions
if [ ! -e "$KISSXML_ADDITIONS_PATH" ]; then
mkdir "$KISSXML_ADDITIONS_PATH"
fi
cp KissXML/Additions/*.h "$KISSXML_ADDITIONS_PATH"

KISSXML_CATEGORIES_PATH=${KISSXML_PATH}/Categories
if [ ! -e "$KISSXML_CATEGORIES_PATH" ]; then
mkdir "$KISSXML_CATEGORIES_PATH"
fi
cp KissXML/Categories/*.h "$KISSXML_CATEGORIES_PATH"

KISSXML_PRIVATE_PATH=${KISSXML_PATH}/Private
if [ ! -e "$KISSXML_PRIVATE_PATH" ]; then
mkdir "$KISSXML_PRIVATE_PATH"
fi
cp KissXML/Private/*.h "$KISSXML_PRIVATE_PATH"

#MBProgressHUD
MBPROGRESSHUD_PATH=${STATICLIB}/MBProgressHUD
if [ ! -e "$MBPROGRESSHUD_PATH" ]; then
mkdir "$MBPROGRESSHUD_PATH"
fi
cp MBProgressHUD/*.h "$JSONKIT_PATH"

#MCSegmentedControl
MCSEGMENTEDCONTROL_PATH=${STATICLIB}/MCSegmentedControl
if [ ! -e "$MCSEGMENTEDCONTROL_PATH" ]; then
	mkdir "$MCSEGMENTEDCONTROL_PATH"
fi
cp MCSegmentedControl/*.h "$MCSEGMENTEDCONTROL_PATH"

#MGSplitViewController
MGSPLITVIEWCONTROLLER_PATH=${STATICLIB}/MGSplitViewController
if [ ! -e "$MGSPLITVIEWCONTROLLER_PATH" ]; then
	mkdir "$MGSPLITVIEWCONTROLLER_PATH"
fi
cp MGSplitViewController/*.h "$MGSPLITVIEWCONTROLLER_PATH"

#NSLogger
NSLOGGER_PATH=${STATICLIB}/NSLogger
if [ ! -e "$NSLOGGER_PATH" ]; then
mkdir "$NSLOGGER_PATH"
fi
cp NSLogger/ClientLogger/iOS/*.h "$NSLOGGER_PATH"

NSLOGGER_DESTOPVIEWER_PATH=${BUILD_PATH}/_Library/DestopViewer
if [ ! -e "$NSLOGGER_DESTOPVIEWER_PATH" ]; then
mkdir "$NSLOGGER_DESTOPVIEWER_PATH"
fi
cp -r NSLogger/DesktopViewer/* "$NSLOGGER_DESTOPVIEWER_PATH"

#NVSlideMenuController
NVSLIDEMENUCONTROLLER_PATH=${STATICLIB}/NVSlideMenuController
if [ ! -e "$NVSLIDEMENUCONTROLLER_PATH" ]; then
mkdir "NVSLIDEMENUCONTROLLER_PATH"
fi
cp NVSlideMenuController/*.h "$NVSLIDEMENUCONTROLLER_PATH"

#Objective-Zip
OBJECTIVEZIP_PATH=${STATICLIB}/Objective-Zip
if [ ! -e "$OBJECTIVEZIP_PATH" ]; then
mkdir "$OBJECTIVEZIP_PATH"
fi
cp Objective-Zip/*.h "$OBJECTIVEZIP_PATH"

OBJECTIVEZIP_OBJECTIVEZIP_PATH=${OBJECTIVEZIP_PATH}/Objective-Zip
if [ ! -e "$OBJECTIVEZIP_OBJECTIVEZIP_PATH" ]; then
mkdir "$OBJECTIVEZIP_OBJECTIVEZIP_PATH"
fi
cp Objective-Zip/Objective-Zip/*.h "$OBJECTIVEZIP_OBJECTIVEZIP_PATH"

OBJECTIVEZIP_ZLIB_PATH=${OBJECTIVEZIP_PATH}/ZLib
if [ ! -e "$OBJECTIVEZIP_ZLIB_PATH" ]; then
mkdir "$OBJECTIVEZIP_ZLIB_PATH"
fi
cp Objective-Zip/ZLib/*.h "$OBJECTIVEZIP_ZLIB_PATH"

#PrettyKit
PRETTYKIT_PATH=${STATICLIB}/PrettyKit
if [ ! -e "$PRETTYKIT_PATH" ]; then
	mkdir "$PRETTYKIT_PATH"
fi
cp PrettyKit/*.h "$PRETTYKIT_PATH"

PRETTYKIT_CELLS_PATH=${PRETTYKIT_PATH}/cells
if [ ! -e "$PRETTYKIT_CELLS_PATH" ]; then
	mkdir "$PRETTYKIT_CELLS_PATH"
fi
cp PrettyKit/cells/*.h "$PRETTYKIT_CELLS_PATH"

#RTLabel
RTLABEL_PATH=${STATICLIB}/RTLabel
if [ ! -e "$RTLABEL_PATH" ]; then
	mkdir "$RTLABEL_PATH"
fi
cp RTLabel/*.h "$RTLABEL_PATH"

#RNTextStatistics
RNTEXTSTATISTICS_PATH=${STATICLIB}/RNTextStatistics
if [ ! -e "$RNTEXTSTATISTICS_PATH" ]; then
mkdir "$RNTEXTSTATISTICS_PATH"
fi
cp RNTextStatistics/*.h "$RNTEXTSTATISTICS_PATH"

#SYCache
SYCACHE_PATH=${STATICLIB}/SYCache
if [ ! -e "$SYCACHE_PATH" ]; then
mkdir "$SYCACHE_PATH"
fi
cp SYCache/*.h "$SYCACHE_PATH"

#SYCompositor
SYCOMPOSITOR_PATH=${STATICLIB}/SYCompositor
if [ ! -e "$SYCOMPOSITOR_PATH" ]; then
mkdir "$SYCOMPOSITOR_PATH"
fi
cp SYCompositor/*.h "$SYCOMPOSITOR_PATH"

#SYPaginator
SYPAGINATOR_PATH=${STATICLIB}/SYPaginator
if [ ! -e "$SYPAGINATOR_PATH" ]; then
mkdir "$SYPAGINATOR_PATH"
fi
cp SYPaginator/*.h "$SYPAGINATOR_PATH"
cp -R SYPaginator/*.bundle "$SYPAGINATOR_PATH"

#SpriteAnimation
SPRITEANIMATION_PATH=${STATICLIB}/SpriteAnimation
if [ ! -e "$SPRITEANIMATION_PATH" ]; then
	mkdir "$SPRITEANIMATION_PATH"
fi
cp SpriteAnimation/*.h "$SPRITEANIMATION_PATH"

#StyledPageControl
STYLEDPAGECONTROL_PATH=${STATICLIB}/StyledPageControl
if [ ! -e "$STYLEDPAGECONTROL_PATH" ]; then
	mkdir "$STYLEDPAGECONTROL_PATH"
fi
cp StyledPageControl/*.h "$STYLEDPAGECONTROL_PATH"

#SVGeocoder
SVGEOCODER_PATH=${STATICLIB}/SVGeocoder
if [ ! -e "$SVGEOCODER_PATH" ]; then
mkdir "$SVGEOCODER_PATH"
fi
cp SVGeocoder/*.h "$SVGEOCODER_PATH"

#SVProgressHUD
SVPROGRESSHUD_PATH=${STATICLIB}/SVProgressHUD
if [ ! -e "$SVPROGRESSHUD_PATH" ]; then
	mkdir "$SVPROGRESSHUD_PATH"
fi
cp SVProgressHUD/*.h "$SVPROGRESSHUD_PATH"
cp -R SVProgressHUD/*.bundle "$SVPROGRESSHUD_PATH"

#SVPullToRefresh
SVPULLTOREFRESH_PATH=${STATICLIB}/SVPullToRefresh
if [ ! -e "$SVPULLTOREFRESH_PATH" ]; then
mkdir "$SVPULLTOREFRESH_PATH"
fi
cp SVPullToRefresh/*.h "$SVPULLTOREFRESH_PATH"
cp -R SVPullToRefresh/*.bundle "$SVPULLTOREFRESH_PATH"

#UAModalPanel
UAMODALPANEL_PATH=${STATICLIB}/UAModalPanel
if [ ! -e "$UAMODALPANEL_PATH" ]; then
	mkdir "$UAMODALPANEL_PATH"
fi
cp UAModalPanel/*.h "$UAMODALPANEL_PATH"
cp -R UAModalPanel/*.bundle "$UAMODALPANEL_PATH"

#UIGlossyButton
UIGLOSSYBUTTON_PATH=${STATICLIB}/UIGlossyButton
if [ ! -e "$UIGLOSSYBUTTON_PATH" ]; then
mkdir "$UIGLOSSYBUTTON_PATH"
fi
cp UIGlossyButton/*.h "$UIGLOSSYBUTTON_PATH"

#UICalendarMonthView
UICALENDARMONTHVIEW_PATH=${STATICLIB}/UICalendarMonthView
if [ ! -e "$UICALENDARMONTHVIEW_PATH" ]; then
mkdir "$UICALENDARMONTHVIEW_PATH"
fi
cp UICalendarMonthView/*.h "$UICALENDARMONTHVIEW_PATH"

#WCAlertView
WCALERTVIEW_PATH=${STATICLIB}/WCAlertView
if [ ! -e "$WCALERTVIEW_PATH" ]; then
mkdir "$WCALERTVIEW_PATH"
fi
cp WCAlertView/*.h "$WCALERTVIEW_PATH"

#ZipArchive
ZIP_PATH=${STATICLIB}/ZipArchive
if [ ! -e "$ZIP_PATH" ]; then
	mkdir "$ZIP_PATH"
fi
cp ZipArchive/*.h "$ZIP_PATH"

ZIP_MINI_PATH=${ZIP_PATH}/minizip
if [ ! -e "$ZIP_MINI_PATH" ]; then
	mkdir "$ZIP_MINI_PATH"
fi
cp ZipArchive/minizip/*.h "$ZIP_MINI_PATH"

find "${STATICLIB}" -name "_*" -exec rm -rf {} \;
find "${STATICLIB}" -name ".*" -exec rm -rf {} \;

open $STATICLIB

exit 0