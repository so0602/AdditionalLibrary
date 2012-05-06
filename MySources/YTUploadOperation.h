#import "YTDefineValues.h"

extern float YTUploadOperationDefaultTimeInterval; //Default: 60s
extern NSString* YTUploadOperationDefaultBoundary; //Default: 1234567890qwertyuiopasdfghjklzxcvbnm

@class YTUploadOperation;

@protocol YTUploadOperationDelegate<NSObject>

-(void)uploadOperationDidFinish:(YTUploadOperation*)operation;

@optional
-(void)uploadOperationDidFail:(YTUploadOperation*)operation;

@end

@protocol YTUploadOperationDataSource

-(NSUInteger)numberOfUploadData:(YTUploadOperation*)operation;
-(NSData*)uploadOperation:(YTUploadOperation*)operation uploadDataAtIndex:(NSUInteger)index;

@end

@interface YTUploadOperation : NSOperation{
@private
	id<YTUploadOperationDelegate> _delegate;
	id<YTUploadOperationDataSource> _dataSource;
	
	id _tag;
	NSURL* _url;
	NSString* _boundary;
	
	NSTimeInterval _timeInterval;
	NSURLConnection* _connection;
	NSMutableData* _returnData;
	NSError* _error;
}

@property (nonatomic, retain) id<YTUploadOperationDelegate> delegate;
@property (nonatomic, retain) id<YTUploadOperationDataSource> dataSource;

@property (nonatomic, retain) id tag;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, copy) NSString* boundary;

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, retain, readonly) NSData* returnData;
@property (nonatomic, retain) NSError* error;

+(id)uploadOperationWithUrl:(NSURL*)url tag:(id)tag delegate:(id<YTUploadOperationDelegate>)delegate dataSource:(id<YTUploadOperationDataSource>)dataSource;

-(NSData*)uploadDataWithName:(NSString*)name fileName:(NSString*)fileName file:(NSData*)file;
-(NSData*)uploadText:(NSString*)text name:(NSString*)name;

-(void)cancel;

@end