#!/bin/sh

# Author: Stephen Cheung
# Version: 2.0


# Release Note:
# v2.0
# 1.Set your app info in autoBuildParames.config file.
# 2.Run ./autoBuild.sh !

# v1.3
# 1.Put this shell and customizeInfo.config, customizeInfo.plist files to project dictionary.

# 2.Create xxxxx.mobileprovision files in Xcode(Version 8.0 and later, use automatically manage signing and DO NOT CHANGE FILE NAME!).
# How to create mobileprovision file refer to help document, and put this file to project dictionary.

# 3.Run shell, parameters as below: 
# $1-your app name, $2-sid, $3-version, $4-build, $5-baidu push key, $6-inside app full name
# eg. ./autoBuild.sh "北京202中学打包" "5303" "9.9.9.0" "999" "o46N2uVsu61ruG0OPgGFI8Pe" "北京202中学" 

# 4.Notices:
#   1).$userPwd is current user login password.
#	2).Only Apple Developer Enterprise Program can be build.
#   3).Make sure a project can be build success in Xcode, and .ipa file can be created in Xcode archive.(IMPORTANT)
#	4).Make sure your developer account infomation valid in Xcode.(IMPORTANT)


# Use xcarchive create ipa or not. Default is "use".
useXcarchiveCreateIpa="use"

# Read parames in autoBuildParams.comfig
while read line
do

paramKey=`echo "$line" | awk -F '=' '{print $1}'`
paramValue=`echo "$line" | awk -F '=' '{print $2}'`

# echo "paramKey $paramKey"
# echo "paramValue $paramValue"

if [ "APP_NAME" = $paramKey ]; then
	# App name
	paramAppName=$paramValue
elif [ "BUILD_TYPE" = $paramKey ]; then
	buildType=$paramValue
elif [ "APP_FULLNAME" = $paramKey ]; then
	# App full name
	paramAppFullName=$paramValue
elif [ "SID" = $paramKey ]; then
	paramSid=$paramValue
elif [ "VERSION" = $paramKey ]; then
	paramVersion=$paramValue
elif [ "BUILD" = $paramKey ]; then
	paramBuild=$paramValue
elif [ "BAIDU_PUSH_KYE" = $paramKey ]; then
	paramBaiduPushKey=$paramValue
elif [ "UMSOCIAL_APPKEY" = $paramKey ]; then
	paramUmsocialAppKey=$paramValue
elif [ "UMSOCIAL_SINA_APPKEY" = $paramKey ]; then
	paramUmsocialSinaAppKey=$paramValue
elif [ "UMSOCIAL_SINA_APPSECRET" = $paramKey ]; then
	paramUmsocialSinaAppSecret=$paramValue
elif [ "UMSOCIAL_SINA_URL_SCHEMES" = $paramKey ]; then
	paramUmsocialSinaUrlSchemes=$paramValue
elif [ "UMSOCIAL_QQ_APPKEY" = $paramKey ]; then
	paramUmsocialQqAppKey=$paramValue
elif [ "UMSOCIAL_QQ_APPSECRET" = $paramKey ]; then
	paramUmsocialQqAppSecret=$paramValue
elif [ "UMSOCIAL_QQ_URL_SCHEMES1" = $paramKey ]; then
	paramUmsocialQqUrlSchemes1=$paramValue
elif [ "UMSOCIAL_QQ_URL_SCHEMES2" = $paramKey ]; then
	paramUmsocialQqUrlSchemes2=$paramValue
elif [ "UMSOCIAL_WECHAT_APPKEY" = $paramKey ]; then
	paramUmsocialWechatAppKey=$paramValue
elif [ "UMSOCIAL_WECHAT_APPSECRET" = $paramKey ]; then
	paramUmsocialWechatAppSecret=$paramValue
elif [ "UMSOCIAL_WECHAT_URL_SCHEMES" = $paramKey ]; then
	paramUmsocialWechatUrlSchemes=$paramValue
fi

done < autoBuildParams.config

# echo "CHECK APP INFO:"
# echo "paramAppName = "$paramAppName""
# echo "paramAppFullName = "$paramAppFullName""

# Chcek parameters.
if [ "" = "$paramAppName" -o "" = "$paramAppFullName" -o "" = "$paramSid" -o "" = "$paramVersion" -o "" = "$paramBuild" ]; then
	echo "\nERROR, not enough params!"
	exit 1
fi

if ls *.mobileprovision >/dev/null 2>&1; then
	# Have mobileprovision file
	echo "All files and parameters are ready..."
else
	echo "\nERROR, .mobileprovision file is not exist!"
	exit 1
fi

# Get project dictionary.
x=`echo $0 | grep "^/"`
if test "${x}"; then
    projPath=$(dirname $0)
else
    projPath=$(dirname `pwd`/$0)
fi

# User dictionary path.
userPath="/Users/"`whoami`

# Import certificate file.
echo "\n** PHASE 1. IMPORT CERTIFICATE FILE **"
# Current user password.
userPwd="mini@5xiaoyuan.cn"

security unlock-keychain -p $userPwd $userPath/Library/Keychains/login.keychain
security list-keychains -s $userPath/Library/Keychains/login.keychain
security import $projPath/school.cer -k $userPath/Library/Keychains/login.keychain -T /usr/bin/codesign
echo "done! \n"

# Provison Profile key.
echo "** PHASE 2. GET PROVISON PROFILE KEY **"
provisionKey=$(grep UUID -A1 -a school.mobileprovision | grep -o "[-A-z0-9]\{36\}")
if [ "" = "$provisionKey" ]; then
echo "ERROR, provisionKey is null, check the provision file pls. \n"
exit 1
fi
echo $provisionKey
if [ "use" != $useXcarchiveCreateIpa ]; then
	sed -i "" "/PROVISIONING_PROFILE/ s/\(.*=\).*/\1$provisionKey/g" customizeInfo.config
fi

# Cpoy provision profile to library path.
cp school.mobileprovision $userPath/Library/MobileDevice/Provisioning\ Profiles/$provisionKey.mobileprovision
echo "done! \n"

echo "** PHASE 3. BUILD INFO CREATING **"
if [ "use" = $useXcarchiveCreateIpa ]; then
	# Replace app name and bundleID in pbxproj file.
	sed -i "" "/PRODUCT_NAME/ s/\(.*=\).*/\1 \"$paramAppName\";/g" ./MicroSchool.xcodeproj/project.pbxproj
	# sed -i "" "/\"CODE_SIGN_IDENTITY[sdk=iphoneos*]\"/ s/\(.*=\).*/\1 \"iPhone Developer\";/g" ./MicroSchool.xcodeproj/project.pbxproj

	sed -i "" "s/ProvisioningStyle = Automatic;/ProvisioningStyle = Manual;/" ./MicroSchool.xcodeproj/project.pbxproj

	# Replace version info.
	/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $paramVersion" ./MicroSchool/MicroSchool-Info.plist
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $paramBuild" ./MicroSchool/MicroSchool-Info.plist

	# Replace youmeng SDK url schemes in MicroSchool-Info.plist.
	/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $paramUmsocialWechatUrlSchemes" ./MicroSchool/MicroSchool-Info.plist
	/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:1:CFBundleURLSchemes:0 $paramUmsocialSinaUrlSchemes" ./MicroSchool/MicroSchool-Info.plist
	/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:2:CFBundleURLSchemes:0 $paramUmsocialQqUrlSchemes1" ./MicroSchool/MicroSchool-Info.plist
	/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:3:CFBundleURLSchemes:0 $paramUmsocialQqUrlSchemes2" ./MicroSchool/MicroSchool-Info.plist

	# Set build type
	if [ "ios99" = $buildType ]; then
		/usr/libexec/PlistBuddy -c "Set :method app-store" exportOptions.plist
		/usr/libexec/PlistBuddy -c "Set :teamID T3KN4SYE62" exportOptions.plist

		# Open youmeng define
		sed -i "" "s/\/\/ #define G_UMSOCIAL_ENABLE/#define G_UMSOCIAL_ENABLE/" ./MicroSchool/Utilities/ThirdVendorSDKKeys.h

		# Change version to 99
		sed -i "" "s/^.*#define G_CERVERSION.*$/#define G_CERVERSION 99/" ./MicroSchool/Utilities/CommonDefine.h

		sed -i "" "/PRODUCT_BUNDLE_IDENTIFIER/ s/\(.*=\).*/\1 com.etaishuo.99weixiao$paramSid;/g" ./MicroSchool.xcodeproj/project.pbxproj
		sed -i "" "/DEVELOPMENT_TEAM/ s/\(.*=\).*/\1 T3KN4SYE62;/g" ./MicroSchool.xcodeproj/project.pbxproj
	elif [ "ios" = $buildType ]; then
		/usr/libexec/PlistBuddy -c "Set :method enterprise" exportOptions.plist
		/usr/libexec/PlistBuddy -c "Set :teamID 6WC9G77P2A" exportOptions.plist

		sed -i "" "/PRODUCT_BUNDLE_IDENTIFIER/ s/\(.*=\).*/\1 com.etaishuo.weixiao$paramSid;/g" ./MicroSchool.xcodeproj/project.pbxproj
		sed -i "" "/DEVELOPMENT_TEAM/ s/\(.*=\).*/\1 6WC9G77P2A;/g" ./MicroSchool.xcodeproj/project.pbxproj
	fi
else
	# CustomizeInfo.config content replace ----------------------------------------------------------------------------
	# Set school name($paramAppName) and bundleID($paramSid) to config file.
	sed -i "" "/PRODUCT_NAME/ s/\(.*=\).*/\1$paramAppName/g" customizeInfo.config
	sed -i "" "/BUNDLE_IDENTIFIER/ s/\(.*=\).*/\1com.etaishuo.weixiao$paramSid/g" customizeInfo.config

	# CustomizeInfo.plist content replace -----------------------------------------------------------------------------
	# Replace line 18: Bundle Identifier.
	sed -i "" "18s/^.*$/	<string>com.etaishuo.weixiao$paramSid<\/string>/" customizeInfo.plist

	# Replace line 26: Version.
	sed -i "" "26s/^.*$/	<string>$paramVersion<\/string>/" customizeInfo.plist

	# Replace line 26: Build.
	sed -i "" "30s/^.*$/	<string>$paramBuild<\/string>/" customizeInfo.plist
fi

# Code replace -----------------------------------------------------------------------------------------------------
# Change server to tag.
sed -i "" "s/^.*#define IS_TEST_SERVER.*$/#define IS_TEST_SERVER 0/" ./MicroSchool/Utilities/CommonDefine.h

# Open build automatically define.
sed -i "" "s/\/\/ #define BUILD_AUTOMATICALLY/#define BUILD_AUTOMATICALLY/" ./MicroSchool/Utilities/CommonDefine.h

# Sid and school name.
sed -i "" "s/^.*#define G_SCHOOL_ID.*$/#define G_SCHOOL_ID @\"$paramSid\"/" ./MicroSchool/Utilities/CommonDefine.h
sed -i "" "s/^.*#define G_SCHOOL_NAME.*$/#define G_SCHOOL_NAME @\"$paramAppFullName\"/" ./MicroSchool/Utilities/CommonDefine.h

# Version and Version name.
sed -i "" "s/^.*#define G_VERSION.*$/#define G_VERSION @\"知校 $paramVersion\"/" ./MicroSchool/Utilities/CommonDefine.h
sed -i "" "s/^.*#define G_APP_VERSION.*$/#define G_APP_VERSION @\"$paramVersion\"/" ./MicroSchool/Utilities/CommonDefine.h

# Baidu push key replacing.
sed -i "" "s/^.*#define G_BAIDU_PUSHKEY.*$/#define G_BAIDU_PUSHKEY @\"$paramBaiduPushKey\"/" ./MicroSchool/Utilities/CommonDefine.h

# Youmeng key
sed -i "" "s/G_UMSOCIAL_APPKEY_VELUE/$paramUmsocialAppKey/g" ./MicroSchool/Utilities/ThirdVendorSDKKeys.h

sed -i "" "s/G_UMSOCIAL_SINA_APPKEY_VELUE/$paramUmsocialSinaAppKey/g" ./MicroSchool/Utilities/ThirdVendorSDKKeys.h
sed -i "" "s/G_UMSOCIAL_SINA_APPSECRET_VELUE/$paramUmsocialSinaAppSecret/g" ./MicroSchool/Utilities/ThirdVendorSDKKeys.h

sed -i "" "s/G_UMSOCIAL_QQ_APPKEY_VELUE/$paramUmsocialQqAppKey/g" ./MicroSchool/Utilities/ThirdVendorSDKKeys.h
sed -i "" "s/G_UMSOCIAL_QQ_APPSECRET_VELUE/$paramUmsocialQqAppSecret/g" ./MicroSchool/Utilities/ThirdVendorSDKKeys.h

sed -i "" "s/G_UMSOCIAL_WECHAT_APPKEY_VELUE/$paramUmsocialWechatAppKey/g" ./MicroSchool/Utilities/ThirdVendorSDKKeys.h
sed -i "" "s/G_UMSOCIAL_WECHAT_APPSECRET_VELUE/$paramUmsocialWechatAppSecret/g" ./MicroSchool/Utilities/ThirdVendorSDKKeys.h
echo "done! \n"



# ************************************** BUILD BEGIN **************************************
echo "** PHASE 4. PROJECT CLEANING **"
echo "get xcodebuild SDK version..."
iphoneosSDK=$(xcodebuild -showsdks | grep "iphoneos" | awk -F' ' '{print $4}')
echo "xcodebuild SDK is $iphoneosSDK"

xcodebuild clean -sdk $iphoneosSDK >/dev/null 2>&1
echo "done! \n"

echo "** PHASE 5. PROJECT BUILDING **"
# Build cocoaPods project to create .a files, -alltargets parameter is always required.
echo "cocoaPods building..."
podsBuildResult=$(xcodebuild -project Pods/Pods.xcodeproj build -alltargets)

# If false then exit 1.
if [ "" = "$podsBuildResult" ]; then
exit 1
fi
echo "cocoaPods build success! \n"

if [ "use" = $useXcarchiveCreateIpa ]; then
	# Build main project.
	echo "microSchool building..."
	buildResult=$(xcodebuild \
	-workspace MicroSchool.xcworkspace \
	-scheme MicroSchool \
	-sdk iphoneos \
	-configuration Release \
	-archivePath ./myApp.xcarchive \
	PROVISIONING_PROFILE="$provisionKey" \
	PROVISIONING_PROFILE_SPECIFIER="$provisionKey" \
	PROVISIONING_PROFILE[sdk=iphoneos*]="$provisionKey" \
	archive)

	# PRODUCT_NAME="$paramAppName" \
	# -xcconfig ./customizeInfo.config \
	# PRODUCT_BUNDLE_IDENTIFIER="com.etaishuo.weixiao$paramSid" \
	# PRODUCT_BUNDLE_IDENTIFIER="com.etaishuo.weixiao6350" \

	# sed -i '' 's/ProvisioningStyle = Automatic;/ProvisioningStyle = Manual;/' ../#{project}/project.pbxproj

	echo "$buildResult" > buildTemp.log
	buildSuccess=$(grep "ARCHIVE SUCCEEDED" buildTemp.log)

	# If false then exit 1.
	# echo $buildResult
	# if [ "" = "$buildSuccess" ]; then
	# exit 1
	# fi

	echo "microSchool build success! \n"

	# Here is export options method: app-store, package, ad-hoc, enterprise, development, and developer-id
	packagingResult=$(xcodebuild \
	-exportArchive \
	-archivePath ./myApp.xcarchive \
	-exportOptionsPlist exportOptions.plist \
	-exportPath ./ipaPackage \
	)

	echo "$packagingResult" > buildExportArchiveTemp.log
	packagingSuccess=$(grep "EXPORT SUCCEEDED" buildExportArchiveTemp.log)

	if [ "" = "$packagingSuccess" ]; then
	exit 1
	fi
	echo "packagingResult success!"

	# # Ipa name.
	ipaName="weixiao_$paramSid"
	cp $projPath/ipaPackage/MicroSchool.ipa $projPath/$ipaName.ipa

	echo "done! \n"
	echo "** ALL PHASE IS COMPLETEED!! Wahahaha **"

	# Ipa file path.
	echo "IPA PATH IS "$projPath$ipaName.ipa"\n"
else
	# old style -----------------------------------------------------------------------------------------------------------------------------

	# Output build result to buildTemp.log file to checkout build errors.
	# NOTICE: .a files created by cocoaPods location could be change. 
	# 		  Then change the ./build/Release-iphoneos location in command line as below if you needed.
	buildResult=$(xcodebuild \
	-sdk $iphoneosSDK \
	-configuration Release \
	-xcconfig ./customizeInfo.config \
	LIBRARY_SEARCH_PATHS="./build/Release-iphoneos ./MicroSchool ./MicroSchool/Utilities/baidu ./MicroSchool/Utilities/amr/lib ./MicroSchool/Utilities/ZBarSDK" \
	)

	echo "$buildResult" > buildTemp.log
	buildSuccess=$(grep "BUILD SUCCEEDED" buildTemp.log)

	# If false then exit 1.
	# echo $buildResult
	if [ "" = "$buildSuccess" ]; then
	exit 1
	fi
	echo "microSchool build success! \n"

	# If success, delete log file.
	# rm buildTemp.log

	echo "done! \n"
	# ************************************** BUILD END *****************************************

	# Ipa name.
	ipaName="weixiao_$paramSid"

	# Create ips file.
	echo "** PHASE 5. IPA CREATING **"
	packagingResult=$(xcrun -sdk iphoneos PackageApplication $projPath/build/Release-iphoneos/$paramAppName.app -o $projPath/$ipaName.ipa)
	echo $packagingResult
	# xcrun -sdk iphoneos PackageApplication $projPath/build/Release-iphoneos/$projName.app -o $projPath$projName.ipa
	echo "done! \n"
	echo "** ALL PHASE IS COMPLETEED!! Wahahaha **"

	# Ipa file path.
	echo "IPA PATH IS "$projPath$ipaName.ipa"\n"
fi

#*
# *          .,:,,,                                        .::,,,::.
# *        .::::,,;;,                                  .,;;:,,....:i:
# *        :i,.::::,;i:.      ....,,:::::::::,....   .;i:,.  ......;i.
# *        :;..:::;::::i;,,:::;:,,,,,,,,,,..,.,,:::iri:. .,:irsr:,.;i.
# *        ;;..,::::;;;;ri,,,.                    ..,,:;s1s1ssrr;,.;r,
# *        :;. ,::;ii;:,     . ...................     .;iirri;;;,,;i,
# *        ,i. .;ri:.   ... ............................  .,,:;:,,,;i:
# *        :s,.;r:... ....................................... .::;::s;
# *        ,1r::. .............,,,.,,:,,........................,;iir;
# *        ,s;...........     ..::.,;:,,.          ...............,;1s
# *       :i,..,.              .,:,,::,.          .......... .......;1,
# *      ir,....:rrssr;:,       ,,.,::.     .r5S9989398G95hr;. ....,.:s,
# *     ;r,..,s9855513XHAG3i   .,,,,,,,.  ,S931,.,,.;s;s&BHHA8s.,..,..:r:
# *    :r;..rGGh,  :SAG;;G@BS:.,,,,,,,,,.r83:      hHH1sXMBHHHM3..,,,,.ir.
# *   ,si,.1GS,   sBMAAX&MBMB5,,,,,,:,,.:&8       3@HXHBMBHBBH#X,.,,,,,,rr
# *   ;1:,,SH:   .A@&&B#&8H#BS,,,,,,,,,.,5XS,     3@MHABM&59M#As..,,,,:,is,
# *  .rr,,,;9&1   hBHHBB&8AMGr,,,,,,,,,,,:h&&9s;   r9&BMHBHMB9:  . .,,,,;ri.
# *  :1:....:5&XSi;r8BMBHHA9r:,......,,,,:ii19GG88899XHHH&GSr.      ...,:rs.
# *  ;s.     .:sS8G8GG889hi.        ....,,:;:,.:irssrriii:,.        ...,,i1,
# *  ;1,         ..,....,,isssi;,        .,,.                      ....,.i1,
# *  ;h:               i9HHBMBBHAX9:         .                     ...,,,rs,
# *  ,1i..            :A#MBBBBMHB##s                             ....,,,;si.
# *  .r1,..        ,..;3BMBBBHBB#Bh.     ..                    ....,,,,,i1;
# *   :h;..       .,..;,1XBMMMMBXs,.,, .. :: ,.               ....,,,,,,ss.
# *    ih: ..    .;;;, ;;:s58A3i,..    ,. ,.:,,.             ...,,,,,:,s1,
# *    .s1,....   .,;sh,  ,iSAXs;.    ,.  ,,.i85            ...,,,,,,:i1;
# *     .rh: ...     rXG9XBBM#M#MHAX3hss13&&HHXr         .....,,,,,,,ih;
# *      .s5: .....    i598X&&A&AAAAAA&XG851r:       ........,,,,:,,sh;
# *      . ihr, ...  .         ..                    ........,,,,,;11:.
# *         ,s1i. ...  ..,,,..,,,.,,.,,.,..       ........,,.,,.;s5i.
# *          .:s1r,......................       ..............;shs,
# *          . .:shr:.  ....                 ..............,ishs.
# *              .,issr;,... ...........................,is1s;.
# *                 .,is1si;:,....................,:;ir1sr;,
# *                    ..:isssssrrii;::::::;;iirsssssr;:..
# *                         .,::iiirsssssssssrri;;:.
# */


