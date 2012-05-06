#import "YTDownloadOperation.h"

float YTDownloadOperationDefaultTimeInterval = 60.0f;
NSString* YTCancelConnectionNotification = @"YTCancelConnectionNotification";

@interface YTDownloadOperation ()

-(id)initWithUrl:(NSURL*)url tag:(id)tag delegate:(id<YTDownloadOperationDelegate>)delegate;
-(id)initWithRequest:(NSURLRequest*)request tag:(id)tag delegate:(id<YTDownloadOperationDelegate>)delegate;

@property (nonatomic, retain, readwrite) NSURLConnection* connection;
//@property (nonatomic, copy, readwrite) NSURLResponse* response;
@property (nonatomic, retain, readwrite) NSURLResponse* response;
@property (nonatomic, retain, readwrite) NSData* data;

@end

@implementation YTDownloadOperation

+(id)downloadOperationWithUrl:(NSURL*)url tag:(id)tag delegate:(id<YTDownloadOperationDelegate>)delegate{
	return [[[YTDownloadOperation alloc] initWithUrl:url tag:tag delegate:delegate] autorelease];
}

+(id)downloadOperationWithRequest:(NSURLRequest*)request tag:(id)tag delegate:(id<YTDownloadOperationDelegate>)delegate{
	return [[[YTDownloadOperation alloc] initWithRequest:request tag:tag delegate:delegate] autorelease];
}

#pragma mark Override Functions

-(void)main{
	NSURLRequest* request = self.request;
	if( !request ) request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeInterval];
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	if( self.connection ) self.data = [NSMutableData data];
}

-(void)cancel{
	[self.connection cancel];
	[super cancel];
}

#pragma mark Private Functions

-(id)initWithUrl:(NSURL*)url tag:(id)tag delegate:(id<YTDownloadOperationDelegate>)delegate{
	if( self = [super init] ){
		self.tag = tag;
		self.url = url;
		self.delegate = delegate;
		self.timeInterval = YTDownloadOperationDefaultTimeInterval;
	}
	return self;
}

-(id)initWithRequest:(NSURLRequest*)request tag:(id)tag delegate:(id<YTDownloadOperationDelegate>)delegate{
	if( self = [super init] ){
		self.tag = tag;
		self.url = [request URL];
		self.request = request;
		self.delegate = delegate;
		self.timeInterval = YTDownloadOperationDefaultTimeInterval;
	}
	return self;
}

#pragma mark NSURLConnectionDelegate Callback

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response{
	self.response = response;
	NSObject<YTDownloadOperationDelegate>* delegate = (NSObject<YTDownloadOperationDelegate>*)_delegate;
	if( ((NSHTTPURLResponse*)response).statusCode == 200 ){
		[_data setLength:0];
	}else{
		self.error = [NSError errorWithDomain:[[response URL] absoluteString] code:((NSHTTPURLResponse*)response).statusCode userInfo:nil];
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
	NSObject<YTDownloadOperationDelegate>* delegate = (NSObject<YTDownloadOperationDelegate>*)_delegate;
	if( [delegate respondsToSelector:@selector(downloadOperationDidFail:)] ){
		[delegate performSelectorOnMainThread:@selector(downloadOperationDidFail:) withObject:self waitUntilDone:TRUE];
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
	NSObject<YTDownloadOperationDelegate>* delegate = (NSObject<YTDownloadOperationDelegate>*)_delegate;
	[delegate performSelectorOnMainThread:@selector(downloadOperationDidFinish:) withObject:self waitUntilDone:TRUE];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self.connection];
	
	self.tag = nil;
	self.url = nil;
	self.request = nil;
	self.data = nil;
	self.timeInterval = 0.0f;
	self.connection = nil;
	self.response = nil;
	self.delegate = nil;
	self.error = nil;
	
	[super dealloc];
}

#pragma mark @synthesize

@synthesize tag = _tag;
@synthesize url = _url;
@synthesize request = _request;
@synthesize data = _data;
@synthesize timeInterval = _timeInterval;
@synthesize connection = _connection;
@synthesize response = _response;
@synthesize delegate = _delegate;
@synthesize error = _error;

@end