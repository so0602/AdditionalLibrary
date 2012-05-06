#import "YTDefineValues.h"

extern float YTDownloadOperationDefaultTimeInterval;
extern NSString* YTCancelConnectionNotification;

@class YTDownloadOperation;

@protocol YTDownloadOperationDelegate<NSObject>

-(void)downloadOperationDidFinish:(YTDownloadOperation*)operation;

@optional
-(void)downloadOperationDidFail:(YTDownloadOperation*)operation;

@end

@interface YTDownloadOperation : NSOperation{
@private
	id _tag;
	NSURL* _url;
	NSURLRequest* _request;
	NSMutableData* _data;
	NSTimeInterval _timeInterval;
	NSURLConnection* _connection;
	NSURLResponse* _response;
	id<YTDownloadOperationDelegate> _delegate;
	NSError* _error;
}

@property (nonatomic, retain) id tag;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, retain) NSURLRequest* request;
@property (nonatomic, retain, readonly) NSData* data;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, retain, readonly) NSURLConnection* connection;
@property (nonatomic, retain, readonly) NSURLResponse* response;
@property (nonatomic, retain) id<YTDownloadOperationDelegate> delegate;
@property (nonatomic, retain) NSError* error;

+(id)downloadOperationWithUrl:(NSURL*)url tag:(id)tag delegate:(id<YTDownloadOperationDelegate>)delegate;
+(id)downloadOperationWithRequest:(NSURLRequest*)request tag:(id)tag delegate:(id<YTDownloadOperationDelegate>)delegate;

@end