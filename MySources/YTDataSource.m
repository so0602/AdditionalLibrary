#import "YTDataSource.h"

static NSString* CodeKey_Data = @"DATA";

@interface YTDataSource ()

@property (nonatomic, retain, readwrite) NSMutableDictionary* data;

@end

@implementation YTDataSource

-(id)initWithDictionary:(NSDictionary*)data{
	if( self = [super init] ){
		if( data ) self.data = [NSMutableDictionary dictionaryWithDictionary:data];
		else self.data = [NSMutableDictionary dictionary];
	}
	return self;
}

+(id)dataSource{
	return [[[self alloc] initWithDictionary:nil] autorelease];
}

+(id)dataSourceWithDictionary:(NSDictionary*)data{
	return [[[self alloc] initWithDictionary:data] autorelease];
}

+(NSArray*)arrayWithDictionaries:(NSArray*)data{
	if( !data ) return nil;
	NSMutableArray* array = [NSMutableArray array];
	for( NSDictionary* dictionary in data ){
		[array addObject:[self dataSourceWithDictionary:dictionary]];
	}
	return [NSArray arrayWithArray:array];
}

-(void)modify:(NSDictionary*)dictionary{
	[_data removeAllObjects];
	[_data setDictionary:dictionary];
}

-(void)insert:(NSDictionary*)dictionary{
	for( NSString* key in dictionary.allKeys ){
		NSObject* values = [dictionary objectForKey:key];
		[_data setObject:values forKey:key];
	}
}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder{
	NSDictionary* dictionary = [aDecoder decodeObjectForKey:CodeKey_Data];
	if( self = [self initWithDictionary:dictionary] ){
		
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:self.data forKey:CodeKey_Data];
}

#pragma mark - Memory Management

-(void)dealloc{
	[_data release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize data = _data;

@end