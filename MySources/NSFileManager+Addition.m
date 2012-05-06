#import "NSFileManager+Addition.h"

#import "NSArray+Addition.h"

@implementation NSFileManager (DocumentPath)

+(BOOL)fileExistsAtDocumentPath:(NSString*)path{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	path = [DocumentPath() stringByAppendingPathComponent:path];
	return [fileManager fileExistsAtPath:path];
}

+(BOOL)removeItemAtDocumentPath:(NSString*)path error:(NSError**)error{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	path = [DocumentPath() stringByAppendingPathComponent:path];
	return [fileManager removeItemAtPath:path error:error];
}

+(BOOL)renameItemAtDocumentPath:(NSString*)path toName:(NSString*)name error:(NSError**)error{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	name = [DocumentPath() stringByAppendingPathComponent:path];
	path = [DocumentPath() stringByAppendingPathComponent:path];
	BOOL success = [fileManager copyItemAtPath:path toPath:name error:error];
	if( !success ) return FALSE;
	
	return [fileManager removeItemAtPath:path error:error];
}

+(NSArray*)itemsAtDocumentPath:(NSString*)path contains:(NSString*)contains{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSArray* files = [fileManager contentsOfDirectoryAtPath:path error:nil];
	return [files filteredArrayWithContains:contains];
}

+(NSArray*)removeItemsAtDocumentPath:(NSString*)path contains:(NSString*)contains{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	NSArray* results = [self itemsAtDocumentPath:path contains:contains];
	for( NSString* file in results ){
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		{
			NSString* filePath = [path stringByAppendingPathComponent:file];
			[fileManager removeItemAtPath:filePath error:nil];
		}
		[pool drain];
	}
	
	return results;
}

@end

@implementation NSFileManager (CachedPath)

+(BOOL)fileExistsAtCachedPath:(NSString*)path{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	path = [CachedPath() stringByAppendingPathComponent:path];
	return [fileManager fileExistsAtPath:path];
}

+(BOOL)removeItemAtCachedPath:(NSString*)path error:(NSError**)error{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	path = [CachedPath() stringByAppendingPathComponent:path];
	return [fileManager removeItemAtPath:path error:error];
}

+(BOOL)renameItemAtCachedPath:(NSString*)path toName:(NSString*)name error:(NSError**)error{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	name = [CachedPath() stringByAppendingPathComponent:path];
	path = [CachedPath() stringByAppendingPathComponent:path];
	BOOL success = [fileManager copyItemAtPath:path toPath:name error:error];
	if( !success ) return FALSE;
	
	return [fileManager removeItemAtPath:path error:error];
}

+(NSArray*)itemsAtCachedPath:(NSString*)path contains:(NSString*)contains{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSArray* files = [fileManager contentsOfDirectoryAtPath:path error:nil];
	return [files filteredArrayWithContains:contains];
}

+(NSArray*)removeItemsAtCachedPath:(NSString*)path contains:(NSString*)contains{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	NSArray* results = [self itemsAtCachedPath:path contains:contains];
	for( NSString* file in results ){
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		{
			NSString* filePath = [path stringByAppendingPathComponent:file];
			[fileManager removeItemAtPath:filePath error:nil];
		}
		[pool drain];
	}
	
	return results;
}

@end