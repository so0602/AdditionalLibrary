#import "YTDownloadOperation.h"

float YTDownloadOperationTimeInterval = 60.0f;
NSString* YTCancelConnectionNotification = @"YTCancelConnectionNotification";

@interface YTDownloadOperation (Private)

-(id)initWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate;
-(void)cancelDownload:(NSNotification*)notification;

@end

@implementation YTDownloadOperation

+(id)downloadOperationWithUrl:(NSURL*)url{
	return [self downloadOperationWithUrl:url tag:nil timeInterval:YTDownloadOperationTimeInterval delegate:nil];
}

+(id)downloadOperationWithUrl:(NSURL*)url tag:(id)tag{
	return [self downloadOperationWithUrl:url tag:tag timeInterval:YTDownloadOperationTimeInterval delegate:nil];
}

+(id)downloadOperationWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval{
	return [self downloadOperationWithUrl:url tag:tag timeInterval:timeInterval delegate:nil];
}

+(id)downloadOperationWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate{
	return [[[YTDownloadOperation alloc] initWithUrl:url tag:tag timeInterval:timeInterval delegate:delegate] autorelease];
}

+(void)cancelAllDownloadOperations{
	[[NSNotificationCenter defaultCenter] postNotificationName:YTCancelConnectionNotification object:nil];
}

+(void)cancelDownloadOperation:(YTDownloadOperation*)operation{
	[[NSNotificationCenter defaultCenter] postNotificationName:YTCancelConnectionNotification object:operation];
}

-(void)cancelDownload{
	[self.connection cancel];
	[self connection:self.connection didFailWithError:nil];
}

#pragma mark Private Functions

-(id)initWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate{
	if( self = [super init] ){
		self.tag = tag;
		self.url = url;
		self.timeInterval = timeInterval;
		self.delegate = delegate;
		
		NSURLRequest* request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeInterval];
		self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
		if( self.connection ) self.data = [NSMutableData data];
		
		[[NSNotificationCenter defaultCenter] addObserver:self.connection selector:@selector(cancel) name:YTCancelConnectionNotification object:nil];
	}
	return self;
}

-(void)cancelDownload:(NSNotification*)notification{
	YTDownloadOperation* operation = (YTDownloadOperation*)[notification object];
	if( [operation isEqual:self] ) [self.connection cancel];
}

#pragma mark NSURLConnectionDelegate Callback

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response{
	NSObject<YTDownloadOperationDelegate>* delegate = (NSObject*)_delegate;
	if( ((NSHTTPURLResponse*)response).statusCode == 200 ){
		[_data setLength:0];
	}else{
		[_connection cancel];
		if( [delegate respondsToSelector:@selector(downloadOperationDidFail:)] ){
			[delegate performSelectorOnMainThread:@selector(downloadOperationDidFail:) withObject:self waitUntilDone:TRUE];
		}
	}
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
	[_data appendData:data];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
	self.error = error;
	[_connection cancel];
	NSObject<YTDownloadOperationDelegate>* delegate = (NSObject*)_delegate;
	if( [delegate respondsToSelector:@selector(downloadOperationDidFail:)] ){
		[delegate performSelectorOnMainThread:@selector(downloadOperationDidFail:) withObject:self waitUntilDone:TRUE];
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
	NSObject<YTDownloadOperationDelegate>* delegate = (NSObject*)_delegate;
	[delegate performSelectorOnMainThread:@selector(downloadOperationDidFinish:) withObject:self waitUntilDone:TRUE];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self.connection];
	
	self.tag = nil;
	self.url = nil;
	self.data = nil;
	self.timeInterval = 0.0f;
	self.connection = nil;
	self.delegate = nil;
	self.error = nil;
	
	[super dealloc];
}

@synthesize tag = _tag;
@synthesize url = _url;
@synthesize data = _data;
@synthesize timeInterval = _timeInterval;
@synthesize connection = _connection;
@synthesize delegate = _delegate;
@synthesize error = _error;

@end