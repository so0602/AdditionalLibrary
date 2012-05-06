#import "YTDefineValues.h"
#import "YTDownloadOperationManager.h"
#import "YTPList.h"
#import "YTGlobalValues.h"

@class YTCachedData;

@protocol YTCachedDataDelegate<NSObject>

@optional
-(void)cachedDataDownloadComplete:(YTCachedData*)data;
-(void)cachedDataDownloadFail:(YTCachedData*)data;

@end

#ifdef __cplusplus
extern "C"
{
#endif
	
	void CachedData(NSURL* url, id tag, NSTimeInterval timeInterval, id<YTCachedDataDelegate> delegate);

#ifdef __cplusplus
}
#endif

@interface YTCachedData : NSObject<YTDownloadOperationDelegate>{
@private
	id<YTCachedDataDelegate> _delegate;
	NSURL* _url;
	id _tag;
	NSTimeInterval _timeInterval; //Default 15s
	
	NSData* _data;
	NSError* _error;
	
	NSString* _fileName;
}

@property (nonatomic, retain) id<YTCachedDataDelegate> delegate;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, retain) id tag;
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, retain) NSData* data;
@property (nonatomic, retain) NSError* error;

@property (nonatomic, retain) NSString* fileName;

+(void)cachedDataWithUrl:(NSURL*)url;
+(void)cachedDataWithUrl:(NSURL*)url timeInterval:(NSTimeInterval)timeInterval;
+(void)cachedDataWithUrl:(NSURL*)url delegate:(id<YTCachedDataDelegate>)delegate;
+(void)cachedDataWithUrl:(NSURL*)url timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedDataDelegate>)delegate;
+(void)cachedDataWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedDataDelegate>)delegate;

+(NSData*)existDataWithUrl:(NSURL*)url;
+(NSString*)existFileNameWithUrl:(NSURL*)url;

+(void)cleanCache;
+(void)cleanCacheWithUrl:(NSURL*)url;
+(void)cleanCacheWithFilename:(NSString*)filename;

@end