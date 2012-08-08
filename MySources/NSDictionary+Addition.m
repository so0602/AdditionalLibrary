#import "NSDictionary+Addition.h"

@implementation NSDictionary (Addition)

-(BOOL)createDatabase:(NSString*)databaseName{
	if( !databaseName ){
		NSLog(@"Database Name is Empty.");
		return FALSE;
	}
	
	FMDatabase* database = [FMDatabase databaseWithPath:[CachedPath() stringByAppendingPathComponent:databaseName]];
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