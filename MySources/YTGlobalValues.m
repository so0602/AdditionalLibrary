#import "YTGlobalValues.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

#define bearingOf(location1, location2) RadiansToDegrees((atan2(sin((location2).coordinate.longitude-(location1).coordinate.longitude)*cos((location2).coordinate.latitude), cos((location1).coordinate.latitude)*sin((location2).coordinate.latitude)-sin((location1).coordinate.latitude)*cos((location2).coordinate.latitude)*cos((location2).coordinate.longitude-(location1).coordinate.longitude))))

NSString* NOT_ENOUGH_UDID = @"NOT_ENOUGH_UDID";

#pragma mark Application Info

UIDevice* CurrentDevice(){
	return [UIDevice currentDevice];
}

NSString* ApplicationName(){
	return (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

NSString* BundleVersion(){
	return (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

NSString* UDID(){
	return CurrentDevice().uniqueIdentifier ? [UIDevice currentDevice].uniqueIdentifier : NOT_ENOUGH_UDID;
}

NSString* CFUDID(){
	CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
	NSString* uuidString = [NSString stringWithString:(NSString*)strRef];
	CFRelease(strRef);
	CFRelease(uuidObj);
	return uuidString;
}

NSString* IPAddress(){
	NSString* address = @"error";
	struct ifaddrs* interfaces = NULL;
	struct ifaddrs* temp_addr = NULL;
	int success = 0;
	
	success = getifaddrs(&interfaces);
	if( success == 0 ){
		temp_addr = interfaces;
		while( temp_addr != NULL ){
			if( temp_addr->ifa_addr->sa_family == AF_INET ){
				if( [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] ){
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	freeifaddrs(interfaces);
	
	return address;
}

BOOL IsIPad(){
	if( RespondsToSelector(CurrentDevice(), @selector(userInterfaceIdiom)) ){
		return CurrentDevice().userInterfaceIdiom == UIUserInterfaceIdiomPad;
	}
	return FALSE;
//	CGRect iPhoneKeyWindowBounds = {{0, 0},{320, 480}};
//	CGRect iPadKeyWindowBounds = {{0, 0},{768, 1024}};
//	return CGRectEqualToRect(KeyWindow().bounds, CGRectMake(0, 0, 768, 1024));
//	return [[CurrentDevice().model lowercaseString] rangeOfString:@"ipad"].location != NSNotFound;
}

BOOL IsHD(){
	NSInteger platformType = [CurrentDevice() platformType];
	return (platformType == UIDeviceiPhoneSimulatoriPhone || platformType == UIDevice4GiPhone || platformType == UIDevice4GiPod);
}

BOOL IsSimulator(){
	return [[CurrentDevice().model lowercaseString] rangeOfString:@"simulator"].location != NSNotFound;
}

#pragma mark Shortcut

UIApplication* SharedApplication(){
	return [UIApplication sharedApplication];
}

UIWindow* KeyWindow(){
	UIWindow* window = nil;
	if( RespondsToSelector(SharedApplication().delegate, @selector(window)) ) window = [SharedApplication().delegate performSelector:@selector(window)];
	if( !window ) window = SharedApplication().keyWindow;
	if( !window && SharedApplication().windows.count != 0 ) window = [SharedApplication().windows objectAtIndex:0];
	return window;
}

BOOL ResignResponder(UIView* view){
	if( [view isFirstResponder] ){
		[view resignFirstResponder];
		return TRUE;
	}
	
	for( UIView* subview in view.subviews ){
		BOOL resign = ResignResponder(subview);
		if( resign ) return TRUE;
	}
	return FALSE;
}

void OpenSafari(NSURL* url){
	[SharedApplication() openURL:url];
}

NSNotificationCenter* NotificationDefaultCenter(){
	return [NSNotificationCenter defaultCenter];
}

void AddNotification(id observer, SEL selector, NSString* name, id object){
	[NotificationDefaultCenter() addObserver:observer selector:selector name:name object:object];
}

void PostNotification(NSString* name, id object){
	[NotificationDefaultCenter() postNotificationName:name object:object];
}

void RemoveNotification(id observer, NSString* name){
	[NotificationDefaultCenter() removeObserver:observer name:name object:nil];
}

void RemoveNotifications(id observer, NSString* firstName, ...){
	NSString* eachName = nil;
	va_list argumentList;
	if( firstName ){
		RemoveNotification(observer, firstName);
		va_start(argumentList, firstName);
		while( (eachName = va_arg(argumentList, NSString*)) ) RemoveNotification(observer, eachName);
		va_end(argumentList);
	}
}

void RemoveAllNotifications(id observer){
	[NotificationDefaultCenter() removeObserver:observer];
}

#pragma mark UserDefaults

NSUserDefaults* UserDefaults(){
	return [NSUserDefaults standardUserDefaults];
}

id ObjectForKeyFromUserDefaults(NSString* key){
	return [UserDefaults() objectForKey:key];
}

void SetObjectToUserDefaults(NSObject* obj, NSString* key){
	[UserDefaults() setObject:obj forKey:key];
}

#pragma mark Clean

void RemoveObjectFromUserDefaults(NSString* key){
	[UserDefaults() removeObjectForKey:key];
}

BOOL RespondsToSelector(id object, SEL sel){
	return [(NSObject*)object respondsToSelector:sel];
}

void ReleaseObject(NSObject** obj){
	[(*obj) release];
	(*obj) = nil;
}

void RemoveSubviewsAtView(UIView* view){
	for( UIView* subview in view.subviews ){
		[subview removeFromSuperview];
	}
}

#pragma mark Math

CGFloat DistanceOf(CGPoint p1, CGPoint p2){
	return sqrt(pow(((p2).x-(p1).x), 2) + pow(((p2).y-(p1).y), 2));
}

CGFloat DegreesToRadians(CGFloat degree){
	return M_PI * degree / 180.0;
}

CGFloat RadiansToDegrees(CGFloat radian){
	return radian * (180.0 / M_PI);
}

double BearingFromAToB(CLLocation* locationA, CLLocation* locationB){
	return bearingOf(locationA, locationB);
}

#pragma mark String

BOOL IsEmptyString(NSString* str){
	return str == nil || str.length == 0;
}

#pragma mark File

NSString* DocumentPath(){
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
}

NSString* ResourcePath(){
	return [[NSBundle mainBundle] resourcePath];
}

NSString* CachedPath(){
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
}

BOOL CopyFileToDocumentPath(NSString* fileName, BOOL isReplace){
	return CopyFileToDocumentPathWithFolder(fileName, nil, isReplace);
}

BOOL CopyFileToDocumentPathWithFolder(NSString* fileName, NSString* folderName, BOOL isReplace){
	if( IsEmptyString(fileName) ) return FALSE;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	NSString* pathFromApp = [ResourcePath() stringByAppendingPathComponent:fileName];
	if( ![fileManager fileExistsAtPath:pathFromApp] ) return FALSE;
	
	CreateFolderToDocumentPath(folderName);
	
	NSString* pathToDoc = nil;
	if( folderName ) pathToDoc = [DocumentPath() stringByAppendingFormat:@"/%@/%@", folderName, fileName];
	else pathToDoc = [DocumentPath() stringByAppendingPathComponent:fileName];
	
	if( FileExistAtDocumentPathWithFolder(fileName, folderName) ){
		if( isReplace ) [fileManager removeItemAtPath:pathToDoc error:nil];
		else return FALSE;
	}
	
	return [fileManager copyItemAtPath:pathFromApp toPath:pathToDoc error:nil];
}

BOOL CreateFolderToDocumentPath(NSString* folderName){
	if( folderName ) return FALSE;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* folderPath = [DocumentPath() stringByAppendingPathComponent:folderName];
	if( ![fileManager fileExistsAtPath:folderPath] ){
		return [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:TRUE attributes:nil error:nil];
	}
	return FALSE;
}

BOOL FileExistAtDocumentPath(NSString* fileName){
	return FileExistAtDocumentPathWithFolder(fileName, nil);
}

BOOL FileExistAtDocumentPathWithFolder(NSString* fileName, NSString* folderName){
	if( !fileName ) return FALSE;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* filePath = nil;
	if( folderName ) filePath = [DocumentPath() stringByAppendingFormat:@"/%@/%@", folderName, fileName];
	else filePath = [DocumentPath() stringByAppendingPathComponent:fileName];
	
	return [fileManager fileExistsAtPath:filePath];
}

#pragma mark Custom Map

BOOL AddViewToCustomMap(UIView* view, UIView* customMap, CLLocation* selfLocation, CLLocation* topLeftLocation, CLLocation* topRightLocation, CLLocation* bottomLeftLocation, CLLocation* bottomRightLocation){
	double bearingOfTopLeft = BearingFromAToB(topLeftLocation, selfLocation);
	if( !(bearingOfTopLeft <= -90 && bearingOfTopLeft >= -180) ) return FALSE;
	double bearingOfTopRight = BearingFromAToB(topRightLocation, selfLocation);
	if( !(bearingOfTopRight >= 90 && bearingOfTopRight <= 180) ) return FALSE;
	double bearingOfBottomLeft = BearingFromAToB(bottomLeftLocation, selfLocation);
	if( !(bearingOfBottomLeft <= 0 && bearingOfBottomLeft >= -90) ) return FALSE;
	double bearingOfBottomRight = BearingFromAToB(bottomRightLocation, selfLocation);
	if( !(bearingOfBottomRight >= 0 && bearingOfBottomRight <= 90) ) return FALSE;
	
	double scale = customMap.transform.a;
	double distanceOfTopLeft = [topLeftLocation getDistanceFrom:selfLocation];
	bearingOfTopLeft += 180;
	double scaleX = (distanceOfTopLeft * sin(DegreesToRadians(bearingOfTopLeft))) / [topLeftLocation getDistanceFrom:topRightLocation];
	double scaleY = (distanceOfTopLeft * cos(DegreesToRadians(bearingOfTopLeft))) / [topLeftLocation getDistanceFrom:bottomLeftLocation];
	view.center = CGPointMake(customMap.frame.size.width * scaleX / scale, customMap.frame.size.height * scaleY / scale - (view.bounds.size.height / 2));
	[customMap addSubview:view];
	return TRUE;
}

#pragma mark Image

UIImage* LocalImage(NSString* imageName, NSString* imageType){
	NSString* path = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
	return [UIImage imageWithContentsOfFile:path];
//	if( [[UIDevice currentDevice].systemVersion compare:@"4.0"] == NSOrderedAscending ){
//		imageName = [NSString stringWithFormat:@"%@.%@", imageName, imageType];
//	}
//	if( [@"jpg" isEqualToString:[imageType lowercaseString]] ){
//		imageName = [NSString stringWithFormat:@"%@%@.%@", imageName, IsHD() ? @"@2x" : @"", imageType];
//	}
//	return [UIImage imageNamed:imageName];
}

UIImage* MixImage(NSArray* images, CGSize size, AlignmentType verticalAlignment, AlignmentType horizontalAlignment){
	if( [[[UIDevice currentDevice] systemVersion] floatValue] < 4.0 ) UIGraphicsBeginImageContext(size);
	else UIGraphicsBeginImageContextWithOptions(size, FALSE, [UIScreen mainScreen].scale);
	
	switch( verticalAlignment + horizontalAlignment ){
		case AlignmentTypeCenter + AlignmentTypeCenter:
			for( UIImage* image in images ) [image drawInRect:CGRectMake((size.width-image.size.width)/2, (size.height-image.size.height)/2, image.size.width, image.size.height)];
			break;
		case AlignmentTypeTop + AlignmentTypeCenter:
			for( UIImage* image in images ) [image drawInRect:CGRectMake((size.width-image.size.width)/2, 0, image.size.width, image.size.height)];
			break;
		case AlignmentTypeBottom + AlignmentTypeCenter:
			for( UIImage* image in images ) [image drawInRect:CGRectMake((size.width-image.size.width)/2, size.height-image.size.height, image.size.width, image.size.height)];
			break;
		case AlignmentTypeCenter + AlignmentTypeLeft:
			for( UIImage* image in images ) [image drawInRect:CGRectMake(0, (size.height-image.size.height)/2, image.size.width, image.size.height)];
			break;
		case AlignmentTypeTop + AlignmentTypeLeft:
			for( UIImage* image in images ) [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
			break;
		case AlignmentTypeBottom + AlignmentTypeLeft:
			for( UIImage* image in images ) [image drawInRect:CGRectMake(0, size.height-image.size.height, image.size.width, image.size.height)];
			break;
		case AlignmentTypeCenter + AlignmentTypeRight:
			for( UIImage* image in images ) [image drawInRect:CGRectMake(size.width-image.size.width, (size.height-image.size.height)/2, image.size.width, image.size.height)];
			break;
		case AlignmentTypeTop + AlignmentTypeRight:
			for( UIImage* image in images ) [image drawInRect:CGRectMake(size.width-image.size.width, 0, image.size.width, image.size.height)];
			break;
		case AlignmentTypeBottom + AlignmentTypeRight:
			for( UIImage* image in images ) [image drawInRect:CGRectMake(size.width-image.size.width, size.height-image.size.height, image.size.width, image.size.height)];
			break;			
	}
	
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

UIImage* Capture(UIView* view){
	UIGraphicsBeginImageContext(view.frame.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}