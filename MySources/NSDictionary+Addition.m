#import "NSDictionary+Addition.h"
#import "NSArray+Addition.h"

#import "YTGlobalValues.h"

@implementation NSDictionary (Addition)

-(BOOL)createDatabase:(NSString*)databaseName{
	if( !databaseName ){
		NSLog(@"Database Name is Empty.");
		return FALSE;
	}
	
	NSString* path = [CachedPath() stringByAppendingPathComponent:databaseName];
	FMDatabase* database = [FMDatabase databaseWithPath:path];
	for( NSString* key in [self allKeys] ){
		NSArray* array = [self objectForKey:key];
		if( array.count == 0 ) continue;
		BOOL result = [array createTable:key atDatabase:database];
		if( !result ) return FALSE;
	}
	[database close];
	
	return TRUE;
}

@end