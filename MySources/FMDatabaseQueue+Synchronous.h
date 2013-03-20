#import "FMDatabaseQueue.h"

@interface FMDatabaseQueue (Synchronous)

-(NSArray*)executQuerySync:(NSString*)statement;
-(BOOL)executeUpdateSync:(NSString*)statement;

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

-(BOOL)insertOrIgnoreInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values;
-(BOOL)insertOrReplaceInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values;

// Values = NSArray of NSDictionary
-(BOOL)multipleInsertOrIgnoreInto:(NSString *)tableName columns:(NSArray *)columns values:(NSArray *)values;
-(BOOL)multipleInsertOrReplaceInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values;

-(BOOL)deleteAllFrom:(NSString*)tableName;
-(BOOL)deleteFrom:(NSString*)tableName where:(NSString*)where;

-(BOOL)update:(NSString*)tableName set:(NSString*)set;
-(BOOL)update:(NSString*)tableName set:(NSString*)set where:(NSString*)where;

-(BOOL)dropTable:(NSString*)tableName;

-(BOOL)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames;
-(BOOL)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames columnTypes:(NSArray*)columnTypes;

-(BOOL)alterTable:(NSString*)preTableName renameTo:(NSString*)tableName;

-(BOOL)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName;
-(BOOL)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName columnType:(NSString*)columnType;

-(NSArray*)pragmaTableInfo:(NSString*)tableName;

-(BOOL)compactDatabase;

@end
