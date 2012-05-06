#import "YTDefineValues.h"
#import "YTDownloadOperationManager.h"
#import "YTPList.h"
#import "YTGlobalValues.h"

@class YTCachedImage;

@protocol YTCachedImageDelegate<NSObject>

@optional
-(void)cachedImageDownloadComplete:(YTCachedImage*)image;
-(void)cachedImageDownloadFail:(YTCachedImage*)image;

@end

#ifdef __cplusplus
extern "C"
{
#endif
	
	void CachedImage(NSURL* url, UIView* view, id tag, NSTimeInterval timeInterval, id<YTCachedImageDelegate> delegate);

#ifdef __cplusplus
}
#endif

@interface YTCachedImage : NSObject<YTDownloadOperationDelegate>{
@private
	id<YTCachedImageDelegate> _delegate;
	NSURL* _url;
	UIView* _view;
	id _tag;
	NSTimeInterval _timeInterval; //Default 15s
	
	UIImage* _image;
	NSError* _error;
	
	NSString* _fileName;
}

@property (nonatomic, retain) id<YTCachedImageDelegate> delegate;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, retain) UIView* view;
@property (nonatomic, retain) id tag;
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSError* error;

@property (nonatomic, retain) NSString* fileName;

+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view;
+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view timeInterval:(NSTimeInterval)timeInterval;
+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view delegate:(id<YTCachedImageDelegate>)delegate;
+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedImageDelegate>)delegate;
+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedImageDelegate>)delegate;
+(UIImage*)existImageWithUrl:(NSURL*)url;
+(NSString*)existFileNameWithUrl:(NSURL*)url;

+(void)cleanCache;
+(void)cleanCacheWithUrl:(NSURL*)url;
+(void)cleanCacheWithFilename:(NSString*)filename;

@end