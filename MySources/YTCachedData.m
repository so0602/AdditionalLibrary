#import "YTCachedData.h"

static NSString* PListName = @"YTCachedData.plist";

#pragma mark YTCachedDataManager

@interface YTCachedDataManager : NSObject{
	YTPList* _plist;
}

@property (nonatomic, retain) YTPList* plist;

+(YTCachedDataManager*)defaultManager;

-(NSData*)existCachedData:(YTCachedData*)cachedData;
-(NSString*)existCachedDataName:(YTCachedData *)cachedData;
-(NSData*)saveCachedData:(YTCachedData*)cachedData data:(NSData*)data;
-(void)cleanCache;
-(void)cleanCacheWithUrl:(NSURL*)url;
-(void)cleanCacheWithFilename:(NSString*)filename;

@end

static YTCachedDataManager* sharedManager;

@implementation YTCachedDataManager

@synthesize plist = _plist;

+(YTCachedDataManager*)defaultManager{
	@synchronized(self){
		if( !sharedManager ) sharedManager = [[YTCachedDataManager alloc] init];
		return sharedManager;
	}
}

-(NSData*)existCachedData:(YTCachedData*)cachedData{
	NSString* fileName = [self existCachedDataName:cachedData];
	if( !fileName ) return nil;
	
	NSData* data = [NSData dataWithContentsOfFile:[CachedPath() stringByAppendingPathComponent:fileName]];
	if( !data ) return nil;
	return data;
}

-(NSString*)existCachedDataName:(YTCachedData *)cachedData{
	return [self.plist objectForKey:[cachedData.url absoluteString]];
}

-(NSData*)saveCachedData:(YTCachedData*)cachedData data:(NSData*)data{
	[self.plist setObject:cachedData.fileName forKey:[cachedData.url absoluteString]];
	[data writeToFile:[CachedPath() stringByAppendingPathComponent:cachedData.fileName] atomically:TRUE];
	return data;
}

-(void)cleanCache{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* filePath = nil;
	for( NSString* filename in [self.plist allValues] ){
		filePath = [CachedPath() stringByAppendingPathComponent:filename];
		if( [fileManager fileExistsAtPath:filePath] ) [fileManager removeItemAtPath:filePath error:nil];
	}
	[self.plist removeAllObjects];
	[self.plist save];
}

-(void)cleanCacheWithUrl:(NSURL*)url{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* key = url.absoluteString;
	NSString* filename = [self.plist objectForKey:key];
	if( filename ){
		NSString* filePath = [CachedPath() stringByAppendingPathComponent:filename];
		if( [fileManager fileExistsAtPath:filePath] ) [fileManager removeItemAtPath:filePath error:nil];
		[self.plist removeObjectForKey:key];
		[self.plist save];
	}
}

-(void)cleanCacheWithFilename:(NSString*)filename{
	if( !filename ) return;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* key = nil;
	for( NSString* k in [self.plist allKeys] ){
		NSString* value = [self.plist objectForKey:k];
		if( [filename isEqualToString:value] ){
			key = k;
			break;
		}
	}
	
	if( !key ) return;
	
	NSString* filePath = [CachedPath() stringByAppendingPathComponent:filename];
	if( [fileManager fileExistsAtPath:filePath] ) [fileManager removeItemAtPath:filePath error:nil];
	[self.plist removeObjectForKey:key];
	[self.plist save];
}

#pragma mark Override Functions

-(id)init{
	if( self = [super init] ){
		self.plist = [[[YTPList alloc] initWithPath:[CachedPath() stringByAppendingPathComponent:PListName] autoSave:TRUE] autorelease];
	}
	return self;
}

#pragma mark Memory Management

-(void)dealloc{
	self.plist = nil;
	
	[super dealloc];
}
@end

#pragma mark -
#pragma mark -
#pragma mark YTCachedData

void CachedData(NSURL* url, id tag, NSTimeInterval timeInterval, id<YTCachedDataDelegate> delegate){
	[YTCachedData cachedDataWithUrl:url timeInterval:timeInterval delegate:delegate];
}

@interface YTCachedData ()

-(id)initWithUrl:(NSURL*)url timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedDataDelegate>)delegate;

@end

@implementation YTCachedData

+(void)cachedDataWithUrl:(NSURL*)url{
	[YTCachedData cachedDataWithUrl:url timeInterval:15 delegate:nil];
}

+(void)cachedDataWithUrl:(NSURL*)url timeInterval:(NSTimeInterval)timeInterval{
	[YTCachedData cachedDataWithUrl:url timeInterval:timeInterval delegate:nil];
}

+(void)cachedDataWithUrl:(NSURL*)url delegate:(id<YTCachedDataDelegate>)delegate{
	[YTCachedData cachedDataWithUrl:url timeInterval:15 delegate:delegate];
}

+(void)cachedDataWithUrl:(NSURL*)url timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedDataDelegate>)delegate{
	[YTCachedData cachedDataWithUrl:url tag:nil timeInterval:timeInterval delegate:delegate];
}

+(void)cachedDataWithUrl:(NSURL*)url tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedDataDelegate>)delegate{
	YTCachedData* cachedData = [[[YTCachedData alloc] initWithUrl:url timeInterval:timeInterval delegate:delegate] autorelease];
	cachedData.tag = tag;
	NSData* data = [[YTCachedDataManager defaultManager] existCachedData:cachedData];
	if( data ){
		cachedData.data = data;
		[cachedData downloadOperationDidFinish:nil];
	}else Download(cachedData.url, cachedData.tag, cachedData.timeInterval, cachedData);
}

+(NSData*)existDataWithUrl:(NSURL*)url{
	YTCachedData* cachedData = [[[YTCachedData alloc] initWithUrl:url timeInterval:0 delegate:nil] autorelease];
	return [[YTCachedDataManager defaultManager] existCachedData:cachedData];
}

+(NSString*)existFileNameWithUrl:(NSURL*)url{
	YTCachedData* cachedImage = [[[YTCachedData alloc] initWithUrl:url timeInterval:0 delegate:nil] autorelease];
	return [[YTCachedDataManager defaultManager] existCachedDataName:cachedImage];
}

+(void)cleanCache{
	[[YTCachedDataManager defaultManager] cleanCache];
}

+(void)cleanCacheWithUrl:(NSURL*)url{
	[[YTCachedDataManager defaultManager] cleanCacheWithUrl:url];
}

+(void)cleanCacheWithFilename:(NSString*)filename{
	[[YTCachedDataManager defaultManager] cleanCacheWithFilename:filename];
}

#pragma mark Private Functions

-(id)initWithUrl:(NSURL*)url timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedDataDelegate>)delegate{
	if( self = [super init] ){
		self.url = url;
		self.timeInterval = timeInterval;
		self.delegate = delegate;
		
		NSString* fileName = [NSString stringWithFormat:@"%0.0f", (float)[[url absoluteString] hash]];
//		fileName = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];
//		NSArray* components = [[url absoluteString] componentsSeparatedByString:@"."];
//		
//		self.fileName = [NSString stringWithFormat:@"%@.%@", fileName, [components lastObject]];
		self.fileName = fileName;
	}
	return self;
}

#pragma mark YTDownloadOperationDelegate Callback

-(void)downloadOperationDidFinish:(YTDownloadOperation*)operation{
	NSData* data = nil;
	if( operation ){
		data = [[YTCachedDataManager defaultManager] saveCachedData:self data:operation.data];
		self.data = data;
	}else data = self.data;
	
	NSObject<YTCachedDataDelegate>* delegate = (NSObject<YTCachedDataDelegate>*)self.delegate;
	if( [delegate respondsToSelector:@selector(cachedDataDownloadComplete:)] ){
		[delegate cachedDataDownloadComplete:self];
	}
}

-(void)downloadOperationDidFail:(YTDownloadOperation*)operation{
	self.error = operation.error;
	NSObject<YTCachedDataDelegate>* delegate = (NSObject<YTCachedDataDelegate>*)self.delegate;
	if( [delegate respondsToSelector:@selector(cachedDataDownloadFail:)] ){
		[delegate cachedDataDownloadFail:self];
	}
}

#pragma mark Memory Management

-(void)dealloc{
	self.delegate = nil;
	self.tag = nil;
	self.url = nil;
	self.timeInterval = 0;
	
	self.data = nil;
	self.error = nil;
	self.fileName = nil;
	
	[super dealloc];
}

#pragma mark @synthesize

@synthesize delegate = _delegate;
@synthesize tag = _tag;
@synthesize url = _url;
@synthesize timeInterval = _timeInterval;
@synthesize data = _data;
@synthesize error = _error;
@synthesize fileName = _fileName;

@end