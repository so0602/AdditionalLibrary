#import "FMDatabaseQueue+Asynchronous.h"

#import "FMDatabaseQueue+Default.h"
#import "NSArray+Addition.h"

#import "FMDatabase.h"
#import "FMResultSet.h"

@interface FMDatabaseQueue (Ayynchronous_Private)

-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit completion:(void(^)(NSArray* results))c;
-(void)insertOr:(NSString*)otherMethod into:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))c;
-(void)multipleInsertOr:(NSString*)otherMethod into:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))c;

@end

@implementation FMDatabaseQueue (Asynchronous)

-(void)executQueryAsync:(NSString*)stmt completion:(void(^)(NSArray* results))c{
    NSAssert2(stmt.length != 0, @"%s [Line: %d] Statement must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    __block NSString* statement = stmt;
    __block void(^completion)(NSArray* results) = c;
    [self inDatabase:^(FMDatabase *db) {
        NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", statement);
        
        NSMutableArray* objects = [NSMutableArray array];
        FMResultSet* rs = [db executeQuery:statement];
        while( rs.next ){
            [objects addObject:rs.resultDictionary];
        }
        
        if( objects.count == 0 ){
            objects = nil;
        }
        
        if( completion ){
            completion(objects);
        }
    }];
}
-(void)executeUpdateAsync:(NSString*)stmt completion:(void(^)(BOOL result))c{
    __block NSString* statement = stmt;
    __block void(^completion)(BOOL result) = c;
    
    [self inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:statement];
        
        if( completion ){
            completion(result);
        }
    }];
}

-(void)selectAllFrom:(NSString*)tableName completion:(void(^)(NSArray* results))completion{
    [self select:nil from:tableName where:nil groupBy:nil orderBy:nil limit:-1 completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName completion:(void(^)(NSArray* results))completion{
    [self select:columns from:tableName where:nil groupBy:nil orderBy:nil limit:-1 completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where completion:(void(^)(NSArray* results))completion{
    [self select:columns from:tableName where:where groupBy:nil orderBy:nil limit:-1 completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy completion:(void(^)(NSArray* results))completion{
    [self select:columns from:tableName where:where groupBy:groupBy orderBy:nil limit:-1 completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy orderBy:(NSString*)orderBy completion:(void(^)(NSArray* results))completion{
    [self select:columns from:tableName where:where groupBy:groupBy orderBy:orderBy limit:-1 completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy orderBy:(NSString*)orderBy limit:(int)limit completion:(void(^)(NSArray* results))completion{
    [self select:columns from:tableName where:where groupBy:groupBy having:nil orderBy:orderBy limit:limit completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName having:(NSString*)having completion:(void(^)(NSArray* results))completion{
	[self select:columns from:tableName groupBy:nil having:having orderBy:nil limit:-1 completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having completion:(void(^)(NSArray* results))completion{
	[self select:columns from:tableName groupBy:groupBy having:having orderBy:nil limit:-1 completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy completion:(void(^)(NSArray* results))completion{
	[self select:columns from:tableName groupBy:groupBy having:having orderBy:orderBy limit:-1 completion:completion];
}

-(void)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit completion:(void(^)(NSArray* results))completion{
    [self select:columns from:tableName where:nil groupBy:groupBy having:having orderBy:orderBy limit:limit completion:completion];
}

-(void)insertOrIgnoreInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))completion{
    [self insertOr:@"IGNORE" into:tableName columns:columns values:values completion:completion];
}

-(void)insertOrReplaceInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))completion{
    [self insertOr:@"REPLACE" into:tableName columns:columns values:values completion:completion];
}

-(void)multipleInsertOrIgnoreInto:(NSString *)tableName columns:(NSArray *)columns values:(NSArray *)values completion:(void(^)(BOOL result))completion{
    [self multipleInsertOr:@"IGNORE" into:tableName columns:columns values:values completion:completion];
}

-(void)multipleInsertOrReplaceInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))completion{
    [self multipleInsertOr:@"REPLACE" into:tableName columns:columns values:values completion:completion];
}

-(void)deleteAllFrom:(NSString*)tableName completion:(void(^)(BOOL result))completion{
    [self deleteFrom:tableName where:nil completion:completion];
}

-(void)deleteFrom:(NSString*)tableName where:(NSString*)where completion:(void(^)(BOOL result))completion{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSMutableString* statement = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    if( where ){
        [statement appendFormat:@"WHERE %@", where];
    }
    
    [self executeUpdateAsync:statement completion:completion];
}

-(void)update:(NSString*)tableName set:(NSString*)set completion:(void(^)(BOOL result))completion{
    [self update:tableName set:set where:nil completion:completion];
}
-(void)update:(NSString*)tableName set:(NSString*)set where:(NSString*)where completion:(void(^)(BOOL result))completion{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(set.length != 0, @"%s [Line: %d] Set must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSMutableString* statement = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    if( where ){
        [statement appendFormat:@"WHERE %@", where];
    }
    
    [self executeUpdateAsync:statement completion:completion];
}

-(void)dropTable:(NSString*)tableName completion:(void(^)(BOOL result))completion{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSString* statement = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    
    return [self executeUpdateAsync:statement completion:completion];
}

-(void)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames completion:(void(^)(BOOL result))completion{
    [self createTable:tableName columnNames:columnNames columnTypes:nil completion:completion];
}
-(void)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames columnTypes:(NSArray*)columnTypes completion:(void(^)(BOOL result))completion{
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
    
    [self executeUpdateAsync:statement completion:completion];
}

-(void)alterTable:(NSString*)preTableName renameTo:(NSString*)tableName completion:(void(^)(BOOL result))completion{
    NSAssert2(preTableName.length != 0, @"%s [Line: %d] Pre-TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(![preTableName isEqualToString:tableName], @"%s [Line: %d] Pre-TableName must not same as TableName", __PRETTY_FUNCTION__, __LINE__);
    
    NSString* statement = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", preTableName, tableName];
    
    [self executeUpdateAsync:statement completion:completion];
}

-(void)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName completion:(void(^)(BOOL result))completion{
    [self alterTable:tableName addColumnName:columnName columnType:nil completion:completion];
}

-(void)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName columnType:(NSString*)columnType completion:(void(^)(BOOL result))completion{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(columnName.length != 0, @"%s [Line: %d] ColumnName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSMutableString* statement = [NSMutableString stringWithFormat:@"ALTER TABLE %@ ADD ", tableName];
    if( columnType.length == 0 ){
        [statement appendString:columnName];
    }else{
        [statement appendString:[NSString stringWithFormat:@"%@ %@", columnName, columnType]];
    }
    
    [self executeUpdateAsync:statement completion:completion];
}

-(void)pragmaTableInfo:(NSString*)tableName completion:(void(^)(NSArray* results))completion{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    
    NSString* statement = [NSString stringWithFormat:@"PRAGMA TABLE_INFO(%@)", tableName];
    
    [self executQueryAsync:statement completion:completion];
}

-(void)compactDatabaseWithcompletion:(void(^)(BOOL result))completion{
    [self executeUpdateAsync:@"VACUUM" completion:completion];
}

#pragma mark - Private Functions

-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit completion:(void(^)(NSArray* results))completion{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(!(where && having), @"%s [Line: %d] Can not have both WHERE & HAVING", __PRETTY_FUNCTION__, __LINE__);
    
    NSMutableString* statement = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@", columns.length == 0 ? @"*" : columns, tableName];
    if( where ) [statement appendFormat:@" WHERE %@", where];
    if( groupBy ) [statement appendFormat:@" GROUP BY %@", groupBy];
    if( having ) [statement appendFormat:@" HAVING %@", having];
    if( orderBy ) [statement appendFormat:@" ORDER BY %@", orderBy];
    if( limit >= 0 ) [statement appendFormat:@" LIMIT %d", limit];
    
    [self executQueryAsync:statement completion:completion];
}

-(void)insertOr:(NSString*)otherMethod into:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))completion{
    NSAssert2(tableName.length != 0, @"%s [Line: %d] TableName must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(columns.count != 0, @"%s [Line: %d] Columns must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(values.count != 0, @"%s [Line: %d] Values must not empty.", __PRETTY_FUNCTION__, __LINE__);
    NSAssert2(columns.count == values.count, @"%s [Line: %d] Columns must match Values", __PRETTY_FUNCTION__, __LINE__);
    
    NSString* columnNameStr = [columns componentsJoinedByString:@", "];
    NSString* columnValueStr = values ? [values componentsJoinedByString:@", "] : @"";
    NSMutableString* statement = [NSMutableString stringWithFormat:@"INSERT OR %@ INTO %@ ( %@ ) VALUES ( %@ );",
                                  otherMethod, tableName, columnNameStr, columnValueStr];
    
    [self executeUpdateAsync:statement completion:completion];
}

-(void)multipleInsertOr:(NSString*)otherMethod into:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))completion{
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
    
    __block BOOL result = TRUE;
    __block NSMutableArray* results = [NSMutableArray arrayWithArray:array];
    
    for( NSArray* values in array ){
        NSMutableString* statement = [NSMutableString stringWithFormat:@"INSERT OR %@ INTO %@ SELECT ", otherMethod, tableName];
        NSDictionary* value = values.firstObject;
        for( NSString* column in columns ){
            NSObject* object = [value objectForKey:column];
            if( [object isKindOfClass:[NSNull class]] || !object ){
                object = @"NULL";
            }
            [statement appendFormat:@"%@ AS %@, ", object, column];
        }
        if( [statement hasSuffix:@","] ){
            [statement replaceCharactersInRange:NSMakeRange(statement.length - 1, 1) withString:@""];
        }
        
        for( int i = 1; i < values.count; i++ ){
            NSDictionary* value = [values objectAtIndex:i];
            NSMutableArray* array = [NSMutableArray array];
            for( NSString* column in columns ){
                NSObject* object = [value objectForKey:column];
                if( [object isKindOfClass:[NSNull class]] || !object ){
                    object = @"NULL";
                }
                [array addObject:object];
            }
            [statement appendFormat:@" UNION SELECT %@", [array componentsJoinedByString:@", "]];
        }
        
        [self executeUpdateAsync:statement completion:^(BOOL r){
            if( result ){
                result = r;
            }
            [results removeLastObject];
            if( results.count == 0 ){
                if( completion ){
                    completion(result);
                }
            }
        }];
    }
}

@end