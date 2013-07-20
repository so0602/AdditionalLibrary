#import "NSArray+Addition.h"

@interface NSArray ()

-(NSString*)ignore:(FilteringOption)option;

@end

@implementation NSArray (Addition)

-(id)firstObject{
<<<<<<< HEAD
    if( self.count == 0 ){
        return nil;
    }
	return [self objectAtIndex:0];
}

-(id)lastSecondObject{
    if( self.count == 0 ){
        return nil;
    }
	return [self objectAtIndex:self.count - 2];
=======
    if( self.count ){
        return [self objectAtIndex:0];
    }
	return nil;
}

-(id)lastSecondObject{
    if( self.count ){
        return [self objectAtIndex:self.count - 2];
    }
	return nil;
>>>>>>> b5a419868ede0dd78541c1b141fc37cb50c1c9a3
}

#pragma mark - Filtering

-(NSArray*)filteredArrayWithMatch:(NSString*)match{
	return [self filteredArrayWithMatch:match inclusive:TRUE];
}

-(NSArray*)filteredArrayWithMatch:(NSString*)match inclusive:(BOOL)inclusive{
	NSPredicate* predicate = nil;
	if( inclusive ) predicate = [NSPredicate predicateWithFormat:@"SELF == %@", match];
	else predicate = [NSPredicate predicateWithFormat:@"SELF != %@", match];
	
	return [self filteredArrayUsingPredicate:predicate];
}

-(NSArray*)filteredArrayWithIn:(NSArray*)objects{
	return [self filteredArrayWithIn:objects inclusive:TRUE];
}

-(NSArray*)filteredArrayWithIn:(NSArray*)objects inclusive:(BOOL)inclusive{
	NSPredicate* predicate = nil;
	if( inclusive ) predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", objects];
	else predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", objects];
	
	return [self filteredArrayUsingPredicate:predicate];
}

-(NSArray*)filteredArrayWithContains:(NSString*)contains{
	return [self filteredArrayWithContains:contains filteringOption:FilteringOption_None inclusive:TRUE];
}

-(NSArray*)filteredArrayWithContains:(NSString*)contains inclusive:(BOOL)inclusive{
	return [self filteredArrayWithContains:contains filteringOption:FilteringOption_None inclusive:inclusive];
}

-(NSArray*)filteredArrayWithContains:(NSString*)contains filteringOption:(FilteringOption)option{
	return [self filteredArrayWithContains:contains filteringOption:option inclusive:TRUE];
}

-(NSArray*)filteredArrayWithContains:(NSString*)contains filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive{
	NSString* format = nil;
	if( inclusive ) format = [NSString stringWithFormat:@"SELF CONTAINS%@ %%@", [self ignore:option]];
	else format = [NSString stringWithFormat:@"NOT (SELF CONTAINS%@ %%@)", [self ignore:option]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:format, contains];
	return [self filteredArrayUsingPredicate:predicate];
}

-(NSArray*)filteredArrayWithLike:(NSString*)like{
	return [self filteredArrayWithLike:like filteringOption:FilteringOption_None inclusive:TRUE];
}

-(NSArray*)filteredArrayWithLike:(NSString*)like inclusive:(BOOL)inclusive{
	return [self filteredArrayWithLike:like filteringOption:FilteringOption_None inclusive:inclusive];
}

-(NSArray*)filteredArrayWithLike:(NSString*)like filteringOption:(FilteringOption)option{
	return [self filteredArrayWithLike:like filteringOption:option inclusive:TRUE];
}

-(NSArray*)filteredArrayWithLike:(NSString*)like filteringOption:(FilteringOption)option inclusive:(BOOL)inclusive{
	NSString* format = nil;
	if( inclusive ) format = [NSString stringWithFormat:@"SELF LIKE%@ %%@", [self ignore:option]];
	else format = [NSString stringWithFormat:@"NOT (SELF LIKE%@ %%@)", [self ignore:option]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:format, like];
	return [self filteredArrayUsingPredicate:predicate];
}

#pragma mark - Private Functions

-(NSString*)ignore:(FilteringOption)option{
	NSString* ignore = @"";
	switch( option ){
		case FilteringOption_Case:
			ignore = @"[c]";
			break;
		case FilteringOption_Diacritic:
			ignore = @"[d]";
			break;
		case FilteringOption_Case | FilteringOption_Diacritic:
			ignore = @"[cd]";
			break;
		default:
			break;
	}
	return ignore;
}

@end

@implementation NSArray (FMDatabase)

-(BOOL)createTable:(NSString*)tableName atDatabase:(FMDatabase*)database{
	NSLog(@"Create Table: %@", tableName);
	if( !tableName ){
		NSLog(@"TableName is null.");
		return FALSE;
	}
	if( !database ){
		NSLog(@"Database is null.");
		return FALSE;
	}
	if( ![database open] ){
		NSLog(@"Could not open database: %@.", database);
		return FALSE;
	}
	if( self.count == 0 ){
		NSLog(@"Empty Array.");
		return FALSE;
	}
	NSDictionary* firstDict = [self objectAtIndex:0];
	if( ![firstDict isKindOfClass:[NSDictionary class]] ){
		NSLog(@"Is not Array of Dictionary.");
		return FALSE;
	}
	
	FMResultSet* rs = nil;
	
	NSMutableString* sql = [NSString stringWithFormat:@"create table if not exists %@ (%@);", tableName, [[firstDict allKeys] componentsJoinedByString:@","]];
    NSLog(@"SQL: %@, columns: %d", sql, firstDict.allKeys.count);
	rs = [database executeQuery:sql];
	[rs next];
	
	sql = [NSString stringWithFormat:@"delete from %@;", tableName];
	//	NSLog(@"SQL: %@", sql);
	rs = [database executeQuery:sql];
	[rs next];
	
	NSMutableString* sql_value = nil;
	NSMutableArray* keyArray = nil;
	NSMutableArray* valueArray = nil;
	
	static int MAX_EACH_COUNT = 25;
	
	int count = self.count / MAX_EACH_COUNT;
	if( self.count % MAX_EACH_COUNT != 0 ) count += 1;
	NSLog(@"self.count: %d", self.count);
	
    NSArray* allKeys = nil;
	for( int i = 0; i < count; i++ ){
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		{
			NSRange range = NSMakeRange(i * MAX_EACH_COUNT, self.count < (i + 1) * MAX_EACH_COUNT ? self.count - (i * MAX_EACH_COUNT) : MAX_EACH_COUNT);
			NSArray* array = [self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
			sql = [NSMutableString string];
			if( array.count == 1 ){
				[sql appendFormat:@"insert into %@ (", tableName];
				sql_value = [NSMutableString stringWithString:@") values ("];
				keyArray = [NSMutableArray array];
				valueArray = [NSMutableArray array];
				NSDictionary* dict = [array objectAtIndex:0];
				int count = 0;
				for( NSString* key in [dict allKeys] ){
					[keyArray addObject:key];
					NSString* value = [dict objectForKey:key];
					[valueArray addObject:value];
					[sql appendFormat:@"'%@'", key];
					if( [value isKindOfClass:[NSString class]] ) value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
					[sql_value appendFormat:@"'%@'", value];
					if( count < [dict allKeys].count - 1 ){
						[sql appendString:@","];
						[sql_value appendString:@","];
					}
					count++;
				}
				[sql_value appendString:@");"];
				[sql appendString:sql_value];
				NSLog(@"sql: %@", sql);
				rs = [database executeQuery:sql];
				[rs next];
			}else{
				[sql appendFormat:@"insert into %@ select ", tableName];
				NSDictionary* firstDict = [array objectAtIndex:0];
				NSMutableArray* values = [NSMutableArray array];
                if( !allKeys ){
                    allKeys = [firstDict.allKeys retain];
                }
				for( NSString* key in allKeys ){
					NSObject* obj = [firstDict objectForKey:key];
					NSString* value = [NSString stringWithFormat:@"'%@' AS '%@'",
											 [obj isKindOfClass:[NSString class]] ?
											 [(NSString*)obj stringByReplacingOccurrencesOfString:@"'" withString:@"''"] :
											 obj, key];
					[values addObject:value];
				}
				[sql appendFormat:@"%@ ", [values componentsJoinedByString:@", "]];
				
				
				for( int j = 1; j < array.count; j++ ){
					firstDict = [array objectAtIndex:j];
					[values removeAllObjects];
					values = [NSMutableArray array];
					for( NSString* key in allKeys ){
						NSObject* obj = [firstDict objectForKey:key];
						NSString* value = [NSString stringWithFormat:@"'%@'",
												 [obj isKindOfClass:[NSString class]] ?
												 [(NSString*)obj stringByReplacingOccurrencesOfString:@"'" withString:@"''"] :
												 obj];
						[values addObject:value];
					}
					[sql appendFormat:@"UNION SELECT %@ ", [values componentsJoinedByString:@", "]];
				}
				NSLog(@"sql: %@", sql);
				rs = [database executeQuery:sql];
				[rs next];
			}
		}
		[pool drain];
	}
    [allKeys release];
	
	return TRUE;
}

@end