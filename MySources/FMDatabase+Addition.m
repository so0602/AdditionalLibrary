#import "FMDatabase+Addition.h"

@interface FMDatabase ()

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit;

@end

@implementation FMDatabase (Addition)

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

#pragma mark - Private Functions

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit{
//    @autoreleasepool {
//        if( !tableName ){
//            return nil;
//        }
//        
//        if( where && having ){
//            NSLog(@"Can not have both WHERE & HAVING");
//            return nil;
//        }
//        
//        sqlite3_stmt* stmt;
//        NSMutableString* str = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@", columns ? columns : @"*", tableName];
//        if( where ) [str appendFormat:@" WHERE %@", where];
//        if( groupBy ) [str appendFormat:@" GROUP BY %@", groupBy];
//        if( having ) [str appendFormat:@" HAVING %@", having];
//        if( orderBy ) [str appendFormat:@" ORDER BY %@", orderBy];
//        if( limit >= 0 ) [str appendFormat:@" LIMIT %d", limit];
//        
//        NSLog(@"\n========== SQL Statement ==========\n\n%@\n\n========== SQL Statement ==========", str);
//        
//        NSMutableArray* objects = nil;
//        FMResultSet* rs = [self executeQuery:str];
//        
//        while( rs.next ){
//            for( int i = 0; i < rs.col)
//        }
//        
//        return objects;
//    }
}
@end