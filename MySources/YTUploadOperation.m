#import "YTUploadOperation.h"

float YTUploadOperationDefaultTimeInterval = 60.0f;
NSString* YTUploadOperationDefaultFileName = @"Unknown";
NSString* YTUploadOperationDefaultBoundary = @"1234567890qwertyuiopasdfghjklzxcvbnm";

@interface YTUploadOperation ()

-(id)initWithUrl:(NSURL*)url tag:(id)tag delegate:(id<YTUploadOperationDelegate>)delegate dataSource:(id<YTUploadOperationDataSource>)dataSource;

@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain, readwrite) NSData* returnData;

@end

@implementation YTUploadOperation

+(id)uploadOperationWithUrl:(NSURL*)url tag:(id)tag delegate:(id<YTUploadOperationDelegate>)delegate dataSource:(id<YTUploadOperationDataSource>)dataSource{
	return [[[YTUploadOperation alloc] initWithUrl:url tag:tag delegate:delegate dataSource:dataSource] autorelease];
}

#pragma mark Override Functions

-(void)main{
	NSInteger numberOfData = [self.dataSource numberOfUploadData:self];
	if( numberOfData == 0 ){
		NSLog(@"Cannot Upload. No More Data");
		return;
	}
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.url];
	[request setHTTPMethod:@"POST"];
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData* postData = [NSMutableData data];
	
	for( int i = 0; i < numberOfData; i++ ){
		[postData appendData:[self.dataSource uploadOperation:self uploadDataAtIndex:i]];
	}
	
	[postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSLog(@"HTTPBody: %@", [[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding] autorelease]);
	[request setHTTPBody:postData];
	
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	if( self.connection ) self.returnData = [NSMutableData data];
}

-(NSData*)uploadDataWithName:(NSString*)name fileName:(NSString*)fileName file:(NSData*)file{
	NSMutableData* data = [NSMutableData data];
	
	[data appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"; filename=\"%@\"\r\n", name, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[NSData dataWithData:file]];
	[data appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	return data;
}

-(NSData*)uploadText:(NSString*)text name:(NSString*)name{
	NSMutableData* data = [NSMutableData data];
	[data appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	return data;
}

-(void)cancel{
	[self.connection cancel];
	[super cancel];
}

#pragma mark Private Functions

-(id)initWithUrl:(NSURL*)url tag:(id)tag delegate:(id<YTUploadOperationDelegate>)delegate dataSource:(id<YTUploadOperationDataSource>)dataSource{
	if( self = [super init] ){
		self.tag = tag;
		self.url = url;
		self.delegate = delegate;
		self.dataSource = dataSource;
		self.timeInterval = YTUploadOperationDefaultTimeInterval;
		
		self.boundary = YTUploadOperationDefaultBoundary;
	}
	return self;
}

#pragma mark NSURLConnectionDelegate Callback

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response{
	NSObject<YTUploadOperationDelegate>* delegate = (NSObject*)_delegate;
	if( ((NSHTTPURLResponse*)response).statusCode == 200 ){
		[_returnData setLength:0];
	}else{
		[_connection cancel];
		if( [delegate respondsToSelector:@selector(uploadOperationDidFail:)] ){
			[delegate performSelectorOnMainThread:@selector(uploadOperationDidFail:) withObject:self waitUntilDone:TRUE];
		}
	}
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
	[_returnData appendData:data];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
	self.error = error;
	[_connection cancel];
	NSObject<YTUploadOperationDelegate>* delegate = (NSObject*)_delegate;
	if( [delegate respondsToSelector:@selector(uploadOperationDidFail:)] ){
		[delegate performSelectorOnMainThread:@selector(uploadOperationDidFail:) withObject:self waitUntilDone:TRUE];
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
	NSObject<YTUploadOperationDelegate>* delegate = (NSObject*)_delegate;
	[delegate performSelectorOnMainThread:@selector(uploadOperationDidFinish:) withObject:self waitUntilDone:TRUE];
}


#pragma mark Memory Management

-(void)dealloc{
	self.delegate = nil;
	self.dataSource = nil;
	
	self.tag = nil;
	self.url = nil;
	self.boundary = nil;
	
	self.timeInterval = 0.0f;
	self.connection = nil;
	self.error = nil;
	
	[super dealloc];
}

#pragma mark @synthesize

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

@synthesize tag = _tag;
@synthesize url = _url;
@synthesize boundary = _boundary;

@synthesize timeInterval = _timeInterval;
@synthesize connection = _connection;
@synthesize returnData = _returnData;
@synthesize error = _error;

@end