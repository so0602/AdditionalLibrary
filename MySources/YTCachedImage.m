#import "YTCachedImage.h"

static NSString* PListName = @"YTCachedImage.plist";

#pragma mark YTCachedImageManager

@interface YTCachedImageManager : NSObject{
	YTPList* _plist;
}

@property (nonatomic, retain) YTPList* plist;

+(YTCachedImageManager*)defaultManager;

-(UIImage*)existCachedImage:(YTCachedImage*)image;
-(NSString*)existCachedImageName:(YTCachedImage *)image;
-(UIImage*)saveCachedImage:(YTCachedImage*)image data:(NSData*)data;
-(void)cleanCache;
-(void)cleanCacheWithUrl:(NSURL*)url;
-(void)cleanCacheWithFilename:(NSString*)filename;

@end

static YTCachedImageManager* sharedManager;

@implementation YTCachedImageManager

@synthesize plist = _plist;

+(YTCachedImageManager*)defaultManager{
	@synchronized(self){
		if( !sharedManager ) sharedManager = [[YTCachedImageManager alloc] init];
		return sharedManager;
	}
}

-(UIImage*)existCachedImage:(YTCachedImage*)image{
	NSString* fileName = [self existCachedImageName:image];
	if( !fileName ) return nil;
	
	NSData* data = [NSData dataWithContentsOfFile:[CachedPath() stringByAppendingPathComponent:fileName]];
	if( !data ) return nil;
	
	return [UIImage imageWithData:data];
}

-(NSString*)existCachedImageName:(YTCachedImage *)image{
	return [self.plist objectForKey:[image.url absoluteString]];
}

-(UIImage*)saveCachedImage:(YTCachedImage*)image data:(NSData*)data{
	[self.plist setObject:image.fileName forKey:[image.url absoluteString]];
	[data writeToFile:[CachedPath() stringByAppendingPathComponent:image.fileName] atomically:TRUE];
	return [UIImage imageWithData:data];
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
#pragma mark YTCachedImage

void CachedImage(NSURL* url, UIView* view, id tag, NSTimeInterval timeInterval, id<YTCachedImageDelegate> delegate){
	[YTCachedImage cachedImageWithUrl:url forView:view timeInterval:timeInterval delegate:delegate];
}

@interface YTCachedImage ()

-(id)initWithUrl:(NSURL*)url forView:(UIView*)view timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedImageDelegate>)delegate;

@end

@implementation YTCachedImage

+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view{
	[YTCachedImage cachedImageWithUrl:url forView:view timeInterval:15 delegate:nil];
}

+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view timeInterval:(NSTimeInterval)timeInterval{
	[YTCachedImage cachedImageWithUrl:url forView:view timeInterval:timeInterval delegate:nil];
}

+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view delegate:(id<YTCachedImageDelegate>)delegate{
	[YTCachedImage cachedImageWithUrl:url forView:view timeInterval:15 delegate:delegate];
}

+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedImageDelegate>)delegate{
	[YTCachedImage cachedImageWithUrl:url forView:view tag:nil timeInterval:timeInterval delegate:delegate];
}

+(void)cachedImageWithUrl:(NSURL*)url forView:(UIView*)view tag:(id)tag timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedImageDelegate>)delegate{
	YTCachedImage* cachedImage = [[[YTCachedImage alloc] initWithUrl:url forView:view timeInterval:timeInterval delegate:delegate] autorelease];
	cachedImage.tag = tag;
	UIImage* image = [[YTCachedImageManager defaultManager] existCachedImage:cachedImage];
	if( image ){
		cachedImage.image = image;
		[cachedImage downloadOperationDidFinish:nil];
	}else Download(cachedImage.url, cachedImage.tag, cachedImage.timeInterval, cachedImage);
}

+(UIImage*)existImageWithUrl:(NSURL*)url{
	YTCachedImage* cachedImage = [[[YTCachedImage alloc] initWithUrl:url forView:nil timeInterval:0 delegate:nil] autorelease];
	return [[YTCachedImageManager defaultManager] existCachedImage:cachedImage];
}

+(NSString*)existFileNameWithUrl:(NSURL*)url{
	YTCachedImage* cachedImage = [[[YTCachedImage alloc] initWithUrl:url forView:nil timeInterval:0 delegate:nil] autorelease];
	return [[YTCachedImageManager defaultManager] existCachedImageName:cachedImage];
}

+(void)cleanCache{
	[[YTCachedImageManager defaultManager] cleanCache];
}

+(void)cleanCacheWithUrl:(NSURL*)url{
	[[YTCachedImageManager defaultManager] cleanCacheWithUrl:url];
}

+(void)cleanCacheWithFilename:(NSString*)filename{
	[[YTCachedImageManager defaultManager] cleanCacheWithFilename:filename];
}

#pragma mark Private Functions

-(id)initWithUrl:(NSURL*)url forView:(UIView*)view timeInterval:(NSTimeInterval)timeInterval delegate:(id<YTCachedImageDelegate>)delegate{
	if( self = [super init] ){
		self.url = url;
		self.view = view;
		self.timeInterval = timeInterval;
		self.delegate = delegate;
		
		NSString* fileName = [NSString stringWithFormat:@"%0.0f", (float)[[url absoluteString] hash]];
		fileName = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];
		NSArray* components = [[url absoluteString] componentsSeparatedByString:@"."];
		
		self.fileName = [NSString stringWithFormat:@"%@.%@", fileName, [components lastObject]];
	}
	return self;
}

#pragma mark YTDownloadOperationDelegate Callback

-(void)downloadOperationDidFinish:(YTDownloadOperation*)operation{
	UIImage* image = nil;
	if( operation ){
		image = [[YTCachedImageManager defaultManager] saveCachedImage:self data:operation.data];
		self.image = image;
	}else image = self.image;
	
	if( [self.view isKindOfClass:[UIImageView class]] ){
		((UIImageView*)self.view).image = image;
	}
	
	NSObject<YTCachedImageDelegate>* delegate = (NSObject<YTCachedImageDelegate>*)self.delegate;
	if( [delegate respondsToSelector:@selector(cachedImageDownloadComplete:)] ){
		[delegate cachedImageDownloadComplete:self];
	}
}

-(void)downloadOperationDidFail:(YTDownloadOperation*)operation{
	self.error = operation.error;
	NSObject<YTCachedImageDelegate>* delegate = (NSObject<YTCachedImageDelegate>*)self.delegate;
	if( [delegate respondsToSelector:@selector(cachedImageDownloadFail:)] ){
		[delegate cachedImageDownloadFail:self];
	}
}

#pragma mark Memory Management

-(void)dealloc{
	self.delegate = nil;
	self.view = nil;
	self.tag = nil;
	self.url = nil;
	self.timeInterval = 0;
	
	self.image = nil;
	self.error = nil;
	self.fileName = nil;
	
	[super dealloc];
}

#pragma mark @synthesize

@synthesize delegate = _delegate;
@synthesize view = _view;
@synthesize tag = _tag;
@synthesize url = _url;
@synthesize timeInterval = _timeInterval;
@synthesize image = _image;
@synthesize error = _error;
@synthesize fileName = _fileName;

@end