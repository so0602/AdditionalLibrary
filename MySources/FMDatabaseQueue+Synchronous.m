#import "FMDatabaseQueue+Synchronous.h"

#import "FMDatabaseQueue+Default.h"

#import "NSArray+Addition.h"

#import "FMDatabase.h"
#import "FMResultSet.h"

@interface FMDatabaseQueue (Synchronous_Private)

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit;
-(BOOL)insertOr:(NSString*)otherMethod into:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values;
-(BOOL)multipleInsertOr:(NSString*)otherMethod into:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values;

@end

@implementation FMDatabaseQueue (Synchronous)

-(NSArray*)executQuerySync:(NSString*)stmt{
    NSAssert2(stmt.length != 0, @"%s [Line: %d] Statement must not empty.", __PRETTY_FUNCTION__, __LINE__);
	
    __block NSString* statement = stmt;
    __block NSMutableArray* objects = [NSMutableArray array];
    
    __block BOOL ended = FALSE;
    
    NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", statement);
    
    [self inDatabase:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:statement];
        while( rs.next ){
            [objects addObject:rs.resultDictionary];
        }
        ended = TRUE;
    }];
    
    NSCondition* condition = [[[NSCondition alloc] init] autorelease];
    [condition lock];
    while( !ended ){
        [condition wait];
    }
    [condition unlock];
    
    return objects.count != 0 ? objects : nil;
}

-(BOOL)executeUpdateSync:(NSString*)stmt{
    __block NSString* statement = stmt;
    __block BOOL result = FALSE;
    __block BOOL ended = FALSE;
    
    NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", statement);
    
    [self inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:statement];
        ended = TRUE;
    }];
    
    NSCondition* condition = [[[NSCondition alloc] init] autorelease];
    [condition lock];
    while( !ended ){
        [condition wait];
    }
    [condition unlock];
    
    return result;
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

-(BOOL)insertOrIgnoreInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values{
    return [self insertOr:@"IGNORE" into:tableName columns:columns values:values];
}

-(BOOL)insertOrReplaceInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values{
    return [self insertOr:@"REPLACE" into:tableName columns:columns values:values];
}

-(BOOL)multipleInsertOrIgnoreInto:(NSString *)tableName columns:(NSArray *)columns values:(NSArray *)values{
    return [self multipleInsertOr:@"IGNORE" into:tableName columns:columns values:values];
}

-(BOOL)multipleInsertOrReplaceInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values{
    return [self multipleInsertOr:@"REPLACE" into:tableName columns:columns values:values];
}

-(BOOL)deleteAllFrom:(NSString*)tableName{
    return [self deleteFrom:tableName where:nil];
}

-(BOOL)deleteFrom:(NSString*)tableName where:(NSString*)where{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSMutableString* statement = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    if( where ){
        [statement appendFormat:@"WHERE %@", where];
    }
    
    return [self executeUpdateSync:statement];
}

-(BOOL)update:(NSString*)tableName set:(NSString*)set{
    return [self update:tableName set:set where:nil];
}

-(BOOL)update:(NSString*)tableName set:(NSString*)set where:(NSString*)where{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(set.length != 0, @"%s [Line: %d] Set must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSMutableString* statement = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    if( where ){
        [statement appendFormat:@"WHERE %@", where];
    }
    
    return [self executeUpdateSync:statement];
}

-(BOOL)dropTable:(NSString*)tableName{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSString* statement = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    
    return [self executeUpdateSync:statement];
}

-(BOOL)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames{
    return [self createTable:tableName columnNames:columnNames columnTypes:nil];
}
-(BOOL)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames columnTypes:(NSArray*)columnTypes{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(columnNames.count != 0, @"%s [Line: %d] ColumnNames must not empty.", __PRETTY_FUNCTION__, __LINE__);
    if( columnTypes ){
        NSAssert2(columnNames.count == columnTypes.count, @"%s [Line: %d] ColumnNames must match ColumnTypes", __PRETTY_FUNCTION__, __LINE__);
    }
    
    NSMutableArray* columns = [NSMutableArray array];
    for( int i = 0; i < columnNames.count; i++ ){
        NSString* columnName = [columnNames objectAtIndex:i];
        NSString* columnType = [columnTypes objectAtIndex:i];
        if( columnType.length == 0 ){
            [columns addObject:columnName];
        }else{
            [columns addObject:[NSString stringWithFormat:@"%@ %@", columnName, columnType]];
        }
    }
    NSMutableString* statement = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( ", tableName];
    [statement appendFormat:@"%@ )", [columns componentsJoinedByString:@", "]];
    
    return [self executeUpdateSync:statement];
}

-(BOOL)alterTable:(NSString*)preTableName renameTo:(NSString*)tableName{
    NSAssert2(preTableName.length != 0, @"%s [Line: %d] Pre-TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(![preTableName isEqualToString:tableName], @"%s [Line: %d] Pre-TableName must not same as TableName", __PRETTY_FUNCTION__, __LINE__);
    
    NSString* statement = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", preTableName, tableName];
    return [self executeUpdateSync:statement];
}

-(BOOL)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName{
    return [self alterTable:tableName addColumnName:columnName columnType:nil];
}

-(BOOL)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName columnType:(NSString*)columnType{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(columnName.length != 0, @"%s [Line: %d] ColumnName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSMutableString* statement = [NSMutableString stringWithFormat:@"ALTER TABLE %@ ADD ", tableName];
    if( columnType.length == 0 ){
        [statement appendString:columnName];
    }else{
        [statement appendString:[NSString stringWithFormat:@"%@ %@", columnName, columnType]];
    }
    
    return [self executeUpdateSync:statement];
}

-(NSArray*)pragmaTableInfo:(NSString *)tableName{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSString* statement = [NSString stringWithFormat:@"PRAGMA TABLE_INFO(%@)", tableName];
    return [self executQuerySync:statement];
}

-(BOOL)compactDatabase{
    return [self executeUpdateSync:@"VACUUM"];
}

#pragma mark Private Functions

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(!(where && having), @"%s [Line: %d] Can not have both WHERE & HAVING", __PRETTY_FUNCTION__, __LINE__);
    
    NSMutableString* statement = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@", columns.length == 0 ? @"*" : columns, tableName];
    if( where ) [statement appendFormat:@" WHERE %@", where];
    if( groupBy ) [statement appendFormat:@" GROUP BY %@", groupBy];
    if( having ) [statement appendFormat:@" HAVING %@", having];
    if( orderBy ) [statement appendFormat:@" ORDER BY %@", orderBy];
    if( limit >= 0 ) [statement appendFormat:@" LIMIT %d", limit];
    
    return [self executQuerySync:statement];
}

-(BOOL)insertOr:(NSString*)otherMethod into:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(columns.count != 0, @"%s [Line: %d] Columns must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(values.count != 0, @"%s [Line: %d] Values must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(columns.count == values.count, @"%s [Line: %d] Columns must match Values", __PRETTY_FUNCTION__, __LINE__);
    
    NSString* columnNameStr = [columns componentsJoinedByString:@", "];
    NSString* columnValueStr = values ? [values componentsJoinedByString:@", "] : @"";
    NSMutableString* statement = [NSMutableString stringWithFormat:@"INSERT OR %@ INTO %@ ( %@ ) VALUES ( %@ );",
                                  otherMethod, tableName, columnNameStr, columnValueStr];
    
    return [self executeUpdateSync:statement];
}

-(BOOL)multipleInsertOr:(NSString*)otherMethod into:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(columns.count != 0, @"%s [Line: %d] Columns must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(values.count != 0, @"%s [Line: %d] Values must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    if( self.maxInsertCount < 5 ){
        self.maxInsertCount = 25;
    }
    NSInteger maxInsertCount = self.maxInsertCount;
    
    NSMutableArray* array = [NSMutableArray array];
    if( values.count <= maxInsertCount ){
        [array addObject:values];
    }else{
        for( NSUInteger i = 0; i * maxInsertCount < values.count; i++ ){
            NSUInteger start = i * maxInsertCount;
            NSRange range = NSMakeRange(start, MIN(values.count - start, maxInsertCount));
            NSArray* subArray = [values subarrayWithRange:range];
            [array addObject:subArray];
        }
    }
    
    BOOL result = TRUE;
    
    for( NSArray* values in array ){
        NSMutableString* statement = [NSMutableString stringWithFormat:@"INSERT OR %@ INTO %@ SELECT ", otherMethod, tableName];
        NSDictionary* value = values.firstObject;
        for( NSString* column in columns ){
            NSObject* object = [value objectForKey:column];
            if( [object isKindOfClass:[NSNull class]] ){
                object = @"NULL";
            }
            [statement appendFormat:@"%@ AS %@, ", object == nil ? @"NULL" : object, column];
        }
        
        if( [statement hasSuffix:@", "] ){
            
            [statement replaceCharactersInRange:NSMakeRange(statement.length - 2, 2) withString:@""];
        }
        for( int i = 1; i < values.count; i++ ){
            NSDictionary* value = [values objectAtIndex:i];
            NSMutableArray* array = [NSMutableArray array];
            for( NSString* column in columns ){
                NSObject* object = [value objectForKey:column];
                if( !object ){
                    object = [NSNull null];
                }
                [array addObject:object];
            }
            [statement appendFormat:@" UNION SELECT %@", [array componentsJoinedByString:@", "]];
        }
        
        BOOL r = [self executeUpdateSync:statement];
        if( result ){
            result = r;
        }
    }
    return result;
}

@end