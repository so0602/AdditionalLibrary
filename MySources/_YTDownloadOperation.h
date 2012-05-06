#import "YTDefineValues.h"

extern float YTDownloadOperationTimeInterval;
extern NSString* YTCancelConnectionNotification;

@class YTDownloadOperation;

@protocol YTDownloadOperationDelegate

-(void)downloadOperationDidFinish:(YTDownloadOperation*)operation;

@optional
-(void)downloadOperationDidFail:(YTDownloadOperation*)operation;

@end

@interface YTDownloadOperation : NSObject{
	
@private
	id _tag;
	NSURL* _url;
	NSMutableData* _data;
	NSTimeInterval _timeInterval;
	NSURLConnection* _connection;
	id<YTDownloadOperationDelegate> _delegate;
	NSError* _error;
}

@property (nonatomic, retain) id tag;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, retain) NSData* data;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain) id<YTDownloadOperationDelegate> delegate;
@property (nonatomic, retain) NSError* error;

+(id)downloadOperationWithUrl:(NSURL*)url;
+(id)downloadOperationWithUrl:(NSURL*)url tag:(id)tag;
+(id)downloadOperationWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval;
+(id)downloadOperationWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate;

+(void)cancelAllDownloadOperations;
+(void)cancelDownloadOperation:(YTDownloadOperation*)operation;

-(void)cancelDownload;

@end