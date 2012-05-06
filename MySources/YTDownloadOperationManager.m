#import "YTDownloadOperationManager.h"

void Download(NSURL* url, id tag, NSTimeInterval timeInterval, id<YTDownloadOperationDelegate> delegate){
	[[YTDownloadOperationManager defaultManager] downloadWithUrl:url tag:tag timeInterval:timeInterval delegate:delegate];
}

#pragma mark -
#pragma mark -
#pragma mark YTDownloadOperationObject

@interface YTDownloadOperationObject : NSObject{
@private
	NSURL* _url;
	id _tag;
	NSTimeInterval _timeInterval;
	id<YTDownloadOperationDelegate> _delegate;
	BOOL _isDownloading;
	YTDownloadOperation* _operation;
}

@property (nonatomic, retain) NSURL* url;
@property (nonatomic, retain) id tag;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, retain) id<YTDownloadOperationDelegate> delegate;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, retain) YTDownloadOperation* operation;

-(id)initWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate;
+(YTDownloadOperationObject*)objectWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate;

@end

@implementation YTDownloadOperationObject

@synthesize url = _url;
@synthesize tag = _tag;
@synthesize timeInterval = _timeInterval;
@synthesize delegate = _delegate;
@synthesize isDownloading = _isDownloading;
@synthesize operation = _operation;

-(id)initWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate{
	if( self = [super init] ){
		self.url = url;
		self.tag = tag;
		self.timeInterval = timeInterval;
		self.delegate = delegate;
		self.isDownloading = FALSE;
	}
	return self;
}

+(YTDownloadOperationObject*)objectWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate{
	return [[[YTDownloadOperationObject alloc] initWithUrl:url tag:tag timeInterval:timeInterval delegate:delegate] autorelease];
}

#pragma mark Memory Management

-(void)dealloc{
	self.url = nil;
	self.tag = nil;
	self.timeInterval = 0;
	self.delegate = nil;
	self.isDownloading = FALSE;
	self.operation = nil;
	
	[super dealloc];
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTDownloadOperationManager

static YTDownloadOperationManager* sharedManager;

@interface YTDownloadOperationManager ()

-(void)downloadNext;

@property (nonatomic, retain) NSMutableDictionary* store;
@property (nonatomic, assign) NSInteger uniKey;
@property (nonatomic, assign) NSUInteger currentDownloadCount;

@end

@implementation YTDownloadOperationManager

@synthesize store = _store;
@synthesize uniKey = _uniKey;
@synthesize maxDownloadCount = _maxDownloadCount;
@synthesize currentDownloadCount = _currentDownloadCount;

+(YTDownloadOperationManager*)defaultManager{
	@synchronized(self){
		if( !sharedManager ){
			sharedManager = [[YTDownloadOperationManager alloc] init];
		}
		return sharedManager;
	}
}

-(void)downloadWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTDownloadOperationDelegate>)delegate{
	@synchronized(self){
		if( !url ) return;
		
		YTDownloadOperationObject* obj = [YTDownloadOperationObject objectWithUrl:url tag:tag timeInterval:timeInterval delegate:delegate];
		NSNumber* key = [NSNumber numberWithInt:self.uniKey++];
		
		[self.store setObject:obj forKey:key];
		
		if( self.currentDownloadCount < self.maxDownloadCount ){
			YTDownloadOperation* operation = [YTDownloadOperation downloadOperationWithUrl:url tag:key delegate:self];
			operation.timeInterval = timeInterval;
			obj.operation = operation;
			obj.isDownloading = TRUE;
			self.currentDownloadCount++;
			[operation start];
		}
	}
}

-(void)cancelDownloadWithTag:(id)tag{
	@synchronized(self){
		if( !tag ) return;
		
		for( id key in [self.store allKeys] ){
			YTDownloadOperationObject* obj = [self.store objectForKey:key];
			if( [obj.tag isEqual:tag] ){				
				if( obj.isDownloading ) [obj.operation cancel];
				else [self.store removeObjectForKey:key];
			}
		}
	}
}

#pragma mark Private Functions

-(void)downloadNext{
	@synchronized(self){
		if( self.currentDownloadCount >= self.maxDownloadCount ) return;
		if( [self.store allKeys].count == 0 ) return;
			
		YTDownloadOperationObject* obj = nil;
		NSNumber* tag = nil;
		for( tag in [self.store allKeys] ){
			obj = [self.store objectForKey:tag];
			if( obj.isDownloading ) obj = nil;
			else break;
		}
		
		if( !obj ) return;
		
		YTDownloadOperation* operation = [YTDownloadOperation downloadOperationWithUrl:obj.url tag:tag delegate:self];
		operation.timeInterval = obj.timeInterval;
		obj.operation = operation;
		obj.isDownloading = TRUE;
		self.currentDownloadCount++;
		[operation start];
	}
}

#pragma mark Override Functions

-(id)init{
	if( self = [super init] ){
		self.store = [NSMutableDictionary dictionary];
		self.uniKey = 0;
		self.maxDownloadCount = 2;
	}
	return self;
}

#pragma mark YTDownloadOperationDelegate Callback

-(void)downloadOperationDidFinish:(YTDownloadOperation*)operation{
	@synchronized(self){
		NSNumber* tag = operation.tag;
		
		YTDownloadOperationObject* obj = [self.store objectForKey:tag];
		operation.tag = obj.tag;
		operation.delegate = obj.delegate;
		
		NSObject<YTDownloadOperationDelegate>* delegate = (NSObject<YTDownloadOperationDelegate>*)operation.delegate;
		[delegate downloadOperationDidFinish:operation];
		
		[self.store removeObjectForKey:tag];
		
		self.currentDownloadCount--;
		[self downloadNext];
	}
}

-(void)downloadOperationDidFail:(YTDownloadOperation*)operation{
	@synchronized(self){
		NSNumber* tag = operation.tag;
		YTDownloadOperationObject* obj = [self.store objectForKey:tag];
		operation.tag = obj.tag;
		operation.delegate = obj.delegate;
		
		NSObject<YTDownloadOperationDelegate>* delegate = (NSObject<YTDownloadOperationDelegate>*)operation.delegate;
		if( [delegate respondsToSelector:@selector(downloadOperationDidFail:)] ){
			[delegate downloadOperationDidFail:operation];
		}
		
		[self.store removeObjectForKey:tag];
		
		self.currentDownloadCount--;
		[self downloadNext];
	}
}

#pragma mark Memory Management

-(void)dealloc{
	self.store = nil;
	self.uniKey = 0;
	self.currentDownloadCount = 0;
	self.maxDownloadCount = 0;
	
	[super dealloc];
}

@end