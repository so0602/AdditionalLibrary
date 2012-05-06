#import "YTPList.h"

@interface YTPList ()

@property (nonatomic, retain) NSMutableDictionary* dictionary;
@property (nonatomic, retain) NSString* path;

@end

@implementation YTPList

@synthesize dictionary = _dictionary;
@synthesize path = _path;
@synthesize autoSave = _autoSave;

-(id)initWithPath:(NSString*)path{
	return [self initWithPath:path autoSave:TRUE];
}

-(id)initWithPath:(NSString*)path autoSave:(BOOL)autoSave{
	if( self = [super init] ){
		self.path = path;
		_autoSave = autoSave;
		self.dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
		if( !self.dictionary ){
			self.dictionary = [NSMutableDictionary dictionary];
			[self save];
		}
	}
	return self;
}

-(void)setObject:(NSObject*)obj forKey:(id)key{
	[self.dictionary setObject:obj forKey:key];
	if( self.autoSave ) [self save];
}

-(id)objectForKey:(id)key{
	return [self.dictionary objectForKey:key];
}

-(void)removeObjectForKey:(id)key{
	[self.dictionary removeObjectForKey:key];
	if( self.autoSave ) [self save];
}

-(void)removeAllObjects{
	[self.dictionary removeAllObjects];
	if( self.autoSave ) [self save];
}

-(void)save{
	[self.dictionary writeToFile:self.path atomically:TRUE];
}

-(void)setAutoSave:(BOOL)save{
	_autoSave = save;
	if( _autoSave ) [self save];
}

-(NSArray*)allKeys{
	return [self.dictionary allKeys];
}

-(NSArray*)allValues{
	return [self.dictionary allValues];
}

#pragma mark Memory Management

-(void)dealloc{
	self.dictionary = nil;
	self.path = nil;
	self.autoSave = FALSE;
	
	[super dealloc];
}

@end