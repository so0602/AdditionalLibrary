#import "YTDatabase.h"

#define DEG2RAD(degrees) ((degrees) * 0.01745327)

static NSString* SqliteMaster = @"sqlite_master";

NSString* PathFromDocument(NSString* name){
	return [DocumentPath() stringByAppendingPathComponent:name];
}

NSString* PathFromCache(NSString* name){
	return [CachedPath() stringByAppendingPathComponent:name];
}

NSString* PathFromResource(NSString* name){
	return [ResourcePath() stringByAppendingPathComponent:name];
}

const char* SqlCleanTable(NSString* tableName){
	return (const char*)[[NSString stringWithFormat:@"DELETE FROM %@", (tableName)] UTF8String];
}

const char* SqlDropTable(NSString* tableName){
	return (const char*)[[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", (tableName)] UTF8String];
}

const char* SqlCreateTable(NSString* tableName, NSString* columnNames){
	return (const char*)[[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( %@ )", (tableName), (columnNames)] UTF8String];
}

const char* SqlRenameTable(NSString* preTableName, NSString* tableName ){
	return (const char*)[[NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", (preTableName), (tableName)] UTF8String];
}

const char* SqlAddColumnToTable(NSString* tableName, NSString* columnName, NSString* columnType){
	return (const char*)[[NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@", (tableName), (columnName), (columnType)] UTF8String];
}

const char* SqlPragmaTable(NSString* tableName){
	return (const char*)[[NSString stringWithFormat:@"PRAGMA TABLE_INFO(%@)", (tableName)] UTF8String];
}

@interface YTDatabase ()

+(BOOL)checkTableName:(NSString*)tableName;

-(void)createDatabase;
-(void)openDatabase:(sqlite3**)database path:(NSString*)path;
-(void)runSQL:(const char*)sql;

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit atDatabase:(sqlite3*)database;

-(NSArray*)pragmaTableInfo:(NSString*)tableName atDatabase:(sqlite3*)database;

@end

@implementation YTDatabase

@synthesize databaseName = _databaseName;
@synthesize database = _database;
@synthesize printLog = _printLog;

static void distanceFunc( sqlite3_context *context, int argc, sqlite3_value **argv ){
	assert( argc == 4 );
	if( sqlite3_value_type( argv[0] ) == SQLITE_NULL || sqlite3_value_type( argv[1] ) == SQLITE_NULL || sqlite3_value_type( argv[2] ) == SQLITE_NULL || sqlite3_value_type( argv[3] ) == SQLITE_NULL ){
		sqlite3_result_null( context );
		return;
	}
	double lat1 = sqlite3_value_double( argv[0] );
	double lon1 = sqlite3_value_double( argv[1] );
	double lat2 = sqlite3_value_double( argv[2] );
	double lon2 = sqlite3_value_double( argv[3] );
	double lat1rad = DEG2RAD(lat1);
	double lat2rad = DEG2RAD(lat2);
	sqlite3_result_double( context, acos( sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1) ) ) * 6378.1 );
}

-(id)initWithName:(NSString*)name copyAtResource:(BOOL)isCopy{
	return [self initWithName:name copyAtResource:isCopy updateToLatest:FALSE];
}

-(id)initWithName:(NSString*)name copyAtResource:(BOOL)isCopy updateToLatest:(BOOL)updateToLatest{
	if( !name ){
		NSLog(@"name must not be nil.");
		return nil;
	}
	
	if( self = [super init] ){
		self.databaseName = name;
		self.printLog = TRUE;
		
		if( isCopy ) CopyFileToDocumentPath(name, FALSE);
		else [self createDatabase];
		
		[self openDatabase:&_database path:PathFromCache(name)];
		
		if( updateToLatest ){
			sqlite3* tempDatabase;
			[self openDatabase:&tempDatabase path:PathFromResource(name)];
			static NSString* NAME = @"name";
			
			NSArray* latestTables = [self select:nil from:SqliteMaster where:@"type = \"table\"" groupBy:nil having:nil orderBy:nil limit:-1 atDatabase:tempDatabase];
			for( NSDictionary* dictionary in latestTables ){
				NSString* tableName = [dictionary objectForKey:NAME];
				NSArray* currentPragmaInfo = [self pragmaTableInfo:tableName];
				NSArray* latestPragmaInfo = [self pragmaTableInfo:tableName atDatabase:tempDatabase];
				if( ![currentPragmaInfo isEqualToArray:latestPragmaInfo] ){
					NSLog(@"Table(%@) will update.", tableName);
					NSString* renamedTable = [NSString stringWithFormat:@"TEMP_%@_TEMP", tableName];
					[self alterTable:tableName renameTo:renamedTable];
					[self runSQL:[[dictionary objectForKey:@"sql"] UTF8String]];
					
					NSMutableArray* columns = [NSMutableArray array];
					for( NSDictionary* each in currentPragmaInfo ){
						NSString* column = [each objectForKey:NAME];
						for( NSDictionary* latestEach in latestPragmaInfo ){
							if( [column isEqualToString:[latestEach objectForKey:NAME]] ){
								[columns addObject:column];
								break;
							}
						}
					}
					
					NSString* columnStr = [columns componentsJoinedByString:@","];
					NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) SELECT %@ FROM %@", tableName, columnStr, columnStr, renamedTable];
					[self runSQL:[sql UTF8String]];
					[self dropTable:renamedTable];
					NSLog(@"Table(%@) updated.", tableName);
					
					NSArray* latestIndexes = [self select:nil from:SqliteMaster where:[NSString stringWithFormat:@"type = \"index\" AND tbl_name = \"%@\"", tableName] groupBy:nil having:nil orderBy:nil limit:-1 atDatabase:tempDatabase];
					for( NSDictionary* latestIndex in latestIndexes ) [self runSQL:[[latestIndex objectForKey:@"sql"] UTF8String]];
				}
			}
			
			[self compactDatabase];
			
			if( tempDatabase ) sqlite3_close(tempDatabase);
			tempDatabase = nil;
		}
	}
	return self;
}

-(id)initWithResourceName:(NSString*)name{
	if( !name ){
		NSLog(@"name must not be nil.");
		return nil;
	}
	
	if( self = [super init] ){
		self.databaseName = name;
		self.printLog = TRUE;
		
		[self openDatabase:&_database path:PathFromResource(name)];
	}
	
	return self;
}

+(id)databaseWithName:(NSString*)name copyAtResource:(BOOL)isCopy{
	return [[[self alloc] initWithName:name copyAtResource:isCopy] autorelease];
}

-(void)cleanTable:(NSString*)tableName{
	if( ![YTDatabase checkTableName:tableName] ) return;
	
	[self runSQL:SqlCleanTable(tableName)];
}

-(void)insertInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values{
	if( ![YTDatabase checkTableName:tableName] ) return;
	
	if( columns == nil ? FALSE : [columns count] != [values count] ){
		NSLog(@"column's count, value's count are not match.");
		return;
	}
	
	if( self.database ){
		sqlite3_stmt* stmt;
		const char* sql = nil;
		NSMutableString* str = nil;
		if( columns != nil ){
			str = [NSMutableString stringWithFormat:@"INSERT INTO %@ ( ", tableName];
			for( int i = 0; i < [columns count] - 1; i++ ) [str appendFormat:@"%@, ", [columns objectAtIndex:i]];
			[str appendFormat:@"%@ ) VALUES ( ", [columns objectAtIndex:[columns count] - 1]];
		}else str = [NSMutableString stringWithFormat:@"INSERT INTO %@ VALUES( ", tableName];
		
		for( int i = 0; i < [values count] - 1; i++ ) [str appendFormat:@"'%@', ", [values objectAtIndex:i]];
		[str appendFormat:@"'%@' );", [values objectAtIndex:[values count] - 1]];
		
		if( self.printLog ) NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", str);
		sql = [str UTF8String];
		
		if( sqlite3_prepare_v2(self.database, sql, -1, &stmt, NULL) != SQLITE_OK ) NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(self.database));
		if( SQLITE_DONE != sqlite3_step(stmt) ) NSAssert1(0, @"Error while inserting. '%s'", sqlite3_errmsg(self.database));
		
		sqlite3_reset( stmt );
	}else NSLog(@"%s Database Error", _cmd);
}

-(NSArray*)selectAllFrom:(NSString*)tableName{
	return [self select:nil from:tableName where:nil groupBy:nil orderBy:nil limit:-1];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName{
	return [self select:columns from:tableName where:nil groupBy:nil orderBy:nil limit:-1];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where{
	return [self select:columns from:tableName where:where groupBy:nil orderBy:nil limit:-1];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy{
	return [self select:columns from:tableName where:where groupBy:groupBy orderBy:nil limit:-1];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy orderBy:(NSString*)orderBy{
	return [self select:columns from:tableName where:where groupBy:groupBy orderBy:orderBy limit:-1];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy orderBy:(NSString*)orderBy limit:(int)limit{
	return [self select:columns from:tableName where:where groupBy:groupBy having:nil orderBy:orderBy limit:limit];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName having:(NSString*)having{
	return [self select:columns from:tableName groupBy:nil having:having orderBy:nil limit:-1];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having{
	return [self select:columns from:tableName groupBy:groupBy having:having orderBy:nil limit:-1];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy{
	return [self select:columns from:tableName groupBy:groupBy having:having orderBy:orderBy limit:-1];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit{
	return [self select:columns from:tableName where:nil groupBy:groupBy having:having orderBy:orderBy limit:limit];
}

-(NSArray*)selectSQLStatement:(NSString*)selectStatement{
	if( !selectStatement ) return nil;
	
	NSMutableArray* objs = nil;
	if( self.database ){
		sqlite3_stmt* stmt;
		if( self.printLog ) NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", selectStatement);
		const char* sql = [selectStatement UTF8String];
		if( sqlite3_prepare_v2(self.database, sql, -1, &stmt, NULL) == SQLITE_OK ){
			objs = [[NSMutableArray alloc] init];
			int count = sqlite3_column_count(stmt);
			while( sqlite3_step(stmt) == SQLITE_ROW ){
				char* c;
				NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
				for( int i = 0; i < count; i++ ){
					c = (char*)sqlite3_column_text(stmt, i);
					[dict setValue:c == nil ? nil : [NSString stringWithUTF8String:c] forKey:[NSString stringWithUTF8String:(char*)sqlite3_column_name(stmt, i)]];
				}
				[objs addObject:dict];
				ReleaseObject(&dict);
			}
		}
	}else NSLog(@"%s: Database Error", _cmd);
	
	return [objs autorelease];
}

-(void)deleteAllFrom:(NSString*)tableName{
	[self deleteFrom:tableName where:nil];
}

-(void)deleteFrom:(NSString*)tableName where:(NSString*)where{
	if( ![YTDatabase checkTableName:tableName] ) return;
	
	if( self.database ){
		sqlite3_stmt* stmt;
		NSMutableString* str = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
		if( where ) [str appendFormat:@" WHERE %@", where];
		
		if( self.printLog ) NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", str);
		
		const char* sql = [str UTF8String];
		if( sqlite3_prepare_v2(self.database, sql, -1, &stmt, NULL) == SQLITE_OK ){
			if( SQLITE_DONE != sqlite3_step(stmt) ) NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(self.database));
			sqlite3_reset(stmt);
		}
	}else NSLog(@"%s: Database Error", _cmd);
}

-(void)update:(NSString*)tableName set:(NSString*)set{
	[self update:tableName set:set where:nil];
}

-(void)update:(NSString*)tableName set:(NSString*)set where:(NSString*)where{
	if( ![YTDatabase checkTableName:tableName] ) return;
	if( !set ) return;
	
	if( self.database ){
		sqlite3_stmt* stmt;
		NSMutableString* str = [NSMutableString stringWithFormat:@"UPDATE %@ SET %@", tableName, set];
		if( where ) [str appendFormat:@" WHERE %@", where];
		
		if( self.printLog ) NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", str);
		
		const char* sql = [str UTF8String];
		if( sqlite3_prepare_v2(self.database, sql, -1, &stmt, NULL) == SQLITE_OK ){
			if( SQLITE_DONE != sqlite3_step(stmt) ) NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(self.database));
			sqlite3_reset(stmt);
		}
	}else NSLog(@"%s: Database Error", _cmd);
}

-(void)dropTable:(NSString*)tableName{
	if( ![YTDatabase checkTableName:tableName] ) return;
	
	[self runSQL:SqlDropTable(tableName)];
}

-(void)createTable:(NSString *)tableName columnNames:(NSArray *)columnNames{
	if( ![YTDatabase checkTableName:tableName] ) return;
	
	if( !columnNames ){
		NSLog(@"columnnames is null.");
		return;
	}
	
	NSMutableString* columns = [NSMutableString string];
	for( int i = 0; i < [columnNames count] - 1; i++ ) [columns appendFormat:@"%@, ", [columnNames objectAtIndex:i]];
	[columns appendString:[columnNames objectAtIndex:[columnNames count] - 1]];
	
	[self runSQL:SqlCreateTable(tableName, columns)];
}

-(void)createTable:(NSString *)tableName columnNames:(NSArray *)columnNames columnTypes:(NSArray *)columnTypes{
	if( ![YTDatabase checkTableName:tableName] ) return;
	
	if( !(columnNames && columnTypes) ){
		NSLog(@"columnNames or/and columnTypes is/are null.");
		return;
	}
	
	if( [columnNames count] != [columnTypes count] ){
		NSLog(@"columnNames is not match columnTypes.");
		return;
	}
	
	NSMutableString* columns = [NSMutableString string];
	for( int i = 0; i < [columnNames count] - 1; i++ ) [columns appendFormat:@"%@ %@, ", [columnNames objectAtIndex:i], [columnTypes objectAtIndex:i]];
	[columns appendFormat:@"%@ %@", [columnNames objectAtIndex:[columnNames count] - 1], [columnTypes objectAtIndex:[columnTypes count] - 1]];
	
	[self runSQL:SqlCreateTable(tableName, columns)];
}

-(void)alterTable:(NSString *)preTableName renameTo:(NSString *)tableName{
	if( ![YTDatabase checkTableName:tableName] ) return;
	if( ![YTDatabase checkTableName:preTableName] ) return;
	
	if( [preTableName isEqualToString:tableName] ){
		NSLog(@"preTableName is same as tableName.");
		return;
	}
	
	[self runSQL:SqlRenameTable(preTableName, tableName)];
}

-(void)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName{
	[self alterTable:tableName addColumnName:columnName columnType:nil];
}

-(void)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName columnType:(NSString*)columnType{
	if( !columnName ){
		NSLog(@"columnName must be haven.");
		return;
	}
	NSArray* columnTypes = nil;
	if( columnType ) columnTypes = [NSArray arrayWithObject:columnType];
	[self alterTable:tableName addColumnNames:[NSArray arrayWithObject:columnName] columnTypes:columnTypes];
}

-(void)alterTable:(NSString*)tableName addColumnNames:(NSArray*)columnNames{
	[self alterTable:tableName addColumnNames:columnNames columnTypes:nil];
}

-(void)alterTable:(NSString*)tableName addColumnNames:(NSArray*)columnNames columnTypes:(NSArray*)columnTypes{
	if( ![YTDatabase checkTableName:tableName] ) return;
	
	if( !columnNames ){
		NSLog(@"columnNames must be haven.");
		return;
	}
	
	if( columnTypes ){
		if( columnNames.count != columnTypes.count ){
			NSLog(@"columnNames count must be same as columnTypes count.");
			return;
		}
		for( int i = 0; i < columnNames.count; i++ ) [self runSQL:SqlAddColumnToTable(tableName, [columnNames objectAtIndex:i], [columnTypes objectAtIndex:i])];
	}else{
		for( int i = 0; i < columnNames.count; i++ ) [self runSQL:SqlAddColumnToTable(tableName, [columnNames objectAtIndex:i], @"")];
	}
}

-(NSArray*)pragmaTableInfo:(NSString*)tableName{
	return [self pragmaTableInfo:tableName atDatabase:self.database];
}

-(void)compactDatabase{
	[self runSQL:[@"VACUUM" UTF8String]];
}

-(void)closeDB{
	if( self.database ) sqlite3_close(self.database);
	self.database = nil;
}

#pragma mark Private Functions

+(BOOL)checkTableName:(NSString *)tableName{
	if( !tableName ) NSLog(@"tableName is null.");
	return tableName != nil;
}

-(void)createDatabase{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	if( [fileManager fileExistsAtPath:PathFromCache(self.databaseName)] ) return;
	
	NSData* tempDBFile = [NSData data];
	[tempDBFile writeToFile:PathFromCache(self.databaseName) atomically:TRUE];
}

-(void)openDatabase:(sqlite3**)database path:(NSString*)path{
	const char* dbPath = [path UTF8String];
	if( sqlite3_open_v2( dbPath, &(*database), SQLITE_OPEN_READWRITE, NULL ) != SQLITE_OK ){
		sqlite3_close(*database);
		*database = nil;
		NSLog(@"Database Failed To Open.");
	}
	sqlite3_create_function(*database, "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
}

-(void)runSQL:(const char*)sql{
	if( self.printLog ) NSLog(@"\n========== SQL Statement ==========\n\n%s\n\n========== SQL Statement ==========", sql);
	if( self.database ){
		sqlite3_stmt* stmt;
		if( sqlite3_prepare_v2(self.database, sql, -1, &stmt, NULL) != SQLITE_OK ) NSAssert1(0, @"Error while creating statement. '%s'", sqlite3_errmsg(self.database));
		if( SQLITE_DONE != sqlite3_step(stmt) ) NSAssert1(0, @"Error: '%s'", sqlite3_errmsg(self.database));
		sqlite3_reset(stmt);
	}else NSLog( @"Database Error" );
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit{	
	return [self select:columns from:tableName where:where groupBy:groupBy having:having orderBy:orderBy limit:limit atDatabase:self.database];
}

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit atDatabase:(sqlite3*)db{
	if( ![YTDatabase checkTableName:tableName] ) return nil;
	
	if( where && having ){
		NSLog(@"Can not have both WHERE & HAVING");
		return nil;
	}
	
	NSMutableArray* objs = nil;
	if( db ){
		sqlite3_stmt* stmt;
		NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"SELECT %@ FROM %@", columns == nil ? @"*" : columns, tableName];
		if( where ) [str appendFormat:@" WHERE %@", where];
		if( groupBy ) [str appendFormat:@" GROUP BY %@", groupBy];
		if( having ) [str appendFormat:@" HAVING %@", having];
		if( orderBy ) [str appendFormat:@" ORDER BY %@", orderBy];
		if( limit >= 0 ) [str appendFormat:@" LIMIT %d", limit];
		if( self.printLog ) NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", str);
		const char* sql = [str UTF8String];
		if( sqlite3_prepare_v2( db, sql, -1, &stmt, NULL ) == SQLITE_OK ){
			objs = [[NSMutableArray alloc] init];
			int count = sqlite3_column_count( stmt );
			NSMutableDictionary* dict = nil;
			while( sqlite3_step( stmt ) == SQLITE_ROW ){
				const char* text;
				const char* name;
				dict = [[NSMutableDictionary alloc] init];
				for( int i = 0; i < count; i++ ){
					text = (const char*)sqlite3_column_text( stmt, i );
					name = (const char*)sqlite3_column_name( stmt, i );
					if( text == nil ) continue;
					
					NSString* value = [[NSString alloc] initWithUTF8String:text];
					NSString* key = [[NSString alloc] initWithUTF8String:name];
					
					[dict setObject:value forKey:key];
					
					[value release], value = nil;
					[key release], key = nil;
				}
				[objs addObject:dict];
				[dict release], dict = nil;
			}
		}
		[str release], str = nil;
	}else NSLog( @"%s: Database Error", _cmd );
	
	return [objs autorelease];
}

-(NSArray*)pragmaTableInfo:(NSString*)tableName atDatabase:(sqlite3*)db{
	if( ![YTDatabase checkTableName:tableName] ) return nil;
	
	NSMutableArray* objs = nil;
	if( db ){
		sqlite3_stmt* stmt;
		if( sqlite3_prepare_v2(db, SqlPragmaTable(tableName), -1, &stmt, NULL) == SQLITE_OK ){
			objs = [[NSMutableArray alloc] init];
			int columnCount = sqlite3_column_count(stmt);
			while( sqlite3_step(stmt) == SQLITE_ROW ){
				char* c;
				NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
				for( int i = 0; i < columnCount; i++ ){
					c = (char*)sqlite3_column_text(stmt, i);
					[dict setValue:c == nil ? nil : [NSString stringWithUTF8String:c] forKey:[NSString stringWithUTF8String:(char*)sqlite3_column_name(stmt, i)]];
				}
				[objs addObject:dict];
				[dict release];
			}
		}
	}else NSLog( @"%s Database Error", _cmd );
	
	return [objs autorelease];
}

#pragma mark - NSCopying

-(id)copyWithZone:(NSZone *)zone{
	return [[[self class] allocWithZone:zone] initWithName:self.databaseName copyAtResource:FALSE];
}

#pragma mark Memory Management

-(void)dealloc{
	[_databaseName release];
	[self closeDB];
	[super dealloc];
}

@end