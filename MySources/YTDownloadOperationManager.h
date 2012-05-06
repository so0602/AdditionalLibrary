#import "YTDefineValues.h"

#import "YTDownloadOperation.h"

#ifdef __cplusplus
extern "C"
{
#endif

void Download(NSURL* url, id tag, NSTimeInterval timeInterval, id<YTDownloadOperationDelegate> delegate);

#ifdef __cplusplus
}
#endif

@interface YTDownloadOperationManager : NSObject<YTDownloadOperationDelegate>{
@private
	NSMutableDictionary* _store;
	NSInteger _uniKey;
	NSUInteger _maxDownloadCount; //Default 2
	NSUInteger _currentDownloadCount;
}

@property (nonatomic, assign) NSUInteger maxDownloadCount;

+(YTDownloadOperationManager*)defaultManager;

-(void)downloadWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate;
-(void)cancelDownloadWithTag:(id)tag;

@end