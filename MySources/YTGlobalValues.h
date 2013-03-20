#import "YTDefineValues.h"

extern NSString* NOT_ENOUGH_UDID;

#import "UIDevice-Hardware.h"

#define YTLogF() YTLog(@"")
#define YTLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define YTLogE(fmt, ...) NSLog((@"ERROR >> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define YTLogW(fmt, ...) NSLog((@"WARNING >> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define YTLogRect(rect) NSLog(@"%s [Line %d] %@", __PRETTY_FUNCTION__, __LINE__, NSStringFromCGRect(rect))
#define YTLogSize(size) NSLog(@"%s [Line %d] %@", __PRETTY_FUNCTION__, __LINE__, NSStringFromCGSize(size))
#define YTLogPoint(point) NSLog(@"%s [Line %d] %@", __PRETTY_FUNCTION__, __LINE__, NSStringFromCGPoint(point))

#ifdef __cplusplus
extern "C"
{
#endif
	
	UIDevice* CurrentDevice();
	
	NSString* ApplicationName();
	NSString* BundleVersion();
	NSString* UDID();
	NSString* CFUDID();
	
	NSString* IPAddress();
	
	BOOL IsIPad();
	BOOL IsHD();
	BOOL IsSimulator();
	
	UIApplication* SharedApplication();
	UIWindow* KeyWindow();
	BOOL ResignResponder(UIView* view);
	
	void OpenSafari(NSURL* url);
	
	NSNotificationCenter* NotificationDefaultCenter();
	void AddNotification(id observer, SEL selector, NSString* name, id object);
	void PostNotification(NSString* name, id object);
	void RemoveNotification(id observer, NSString* name);
	void RemoveNotifications(id observer, NSString* firstName, ...);
	void RemoveAllNotifications(id observer);
	
	NSUserDefaults* UserDefaults();
	id ObjectForKeyFromUserDefaults(NSString* key);
	void SetObjectToUserDefaults(NSObject* obj, NSString* key);
	void RemoveObjectFromUserDefaults(NSString* key);
	
	BOOL RespondsToSelector(id object, SEL sel);
	void ReleaseObject(NSObject** obj);
	
	void RemoveSubviewsAtView(UIView* view);
	
	CGFloat DistanceOf(CGPoint p1, CGPoint p2);
	CGFloat DegreesToRadians(CGFloat degree);
	CGFloat RadiansToDegrees(CGFloat radian);
	double BearingFromAToB(CLLocation* locationA, CLLocation* locationB);
	
	BOOL IsEmptyString(NSString* str);
	
	NSString* DocumentPath();
	NSString* ResourcePath();
	NSString* CachedPath();
	
	BOOL CopyFileToDocumentPath(NSString* fileName, BOOL isReplace);
	BOOL CopyFileToDocumentPathWithFolder(NSString* fileName, NSString* folderName, BOOL isReplace);
	
	BOOL CreateFolderToDocumentPath(NSString* folderName);
	
	BOOL FileExistAtDocumentPath(NSString* fileName);
	BOOL FileExistAtDocumentPathWithFolder(NSString* fileName, NSString* folderName);
	
	BOOL AddViewToCustomMap(UIView* view, UIView* customMap, CLLocation* selfLocation, CLLocation* topLeftLocation, CLLocation* topRightLocation, CLLocation* bottomLeftLocation, CLLocation* bottomRightLocation);
	
	UIImage* LocalImage(NSString* imageName, NSString* imageType);
	UIImage* MixImage(NSArray* images, CGSize size, AlignmentType verticalAlignment, AlignmentType horizontalAlignment);
	UIImage* Capture(UIView* view);
	
#ifdef __cplusplus
}
#endif