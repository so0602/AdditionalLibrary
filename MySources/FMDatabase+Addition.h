#import "FMDatabase.h"

@interface FMDatabase (Addition)

-(NSArray*)selectAllFrom:(NSString*)tableName;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy orderBy:(NSString*)orderBy;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy orderBy:(NSString*)orderBy limit:(int)limit;

-(NSArray*)select:(NSString*)columns from:(NSString*)tableName having:(NSString*)having;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy;
-(NSArray*)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit;

-(NSArray*)selectSQLStatement:(NSString*)selectStatement;

@end