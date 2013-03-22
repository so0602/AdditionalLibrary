#import "FMDatabaseQueue.h"

@interface FMDatabaseQueue (Asynchronous)

-(void)executQueryAsync:(NSString*)statement completion:(void(^)(NSArray* results))completion;
-(void)executeUpdateAsync:(NSString*)statement completion:(void(^)(BOOL result))completion;

-(void)selectAllFrom:(NSString*)tableName completion:(void(^)(NSArray* results))completion;
-(void)select:(NSString*)columns from:(NSString*)tableName completion:(void(^)(NSArray* results))completion;
-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where completion:(void(^)(NSArray* results))completion;
-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy completion:(void(^)(NSArray* results))completion;
-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy orderBy:(NSString*)orderBy completion:(void(^)(NSArray* results))completion;
-(void)select:(NSString*)columns from:(NSString*)tableName where:(NSString*)where groupBy:(NSString*)groupBy orderBy:(NSString*)orderBy limit:(int)limit completion:(void(^)(NSArray* results))completion;

-(void)select:(NSString*)columns from:(NSString*)tableName having:(NSString*)having completion:(void(^)(NSArray* results))completion;
-(void)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having completion:(void(^)(NSArray* results))completion;
-(void)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy completion:(void(^)(NSArray* results))completion;
-(void)select:(NSString*)columns from:(NSString*)tableName groupBy:(NSString*)groupBy having:(NSString*)having orderBy:(NSString*)orderBy limit:(int)limit completion:(void(^)(NSArray* results))completion;

-(void)insertOrIgnoreInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))completion;
-(void)insertOrReplaceInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))completion;

// Values = NSArray of NSDictionary
-(void)multipleInsertOrIgnoreInto:(NSString *)tableName columns:(NSArray *)columns values:(NSArray *)values completion:(void(^)(BOOL result))completion;
-(void)multipleInsertOrReplaceInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values completion:(void(^)(BOOL result))completion;

-(void)deleteAllFrom:(NSString*)tableName completion:(void(^)(BOOL result))completion;
-(void)deleteFrom:(NSString*)tableName where:(NSString*)where completion:(void(^)(BOOL result))completion;

-(void)update:(NSString*)tableName set:(NSString*)set completion:(void(^)(BOOL result))completion;
-(void)update:(NSString*)tableName set:(NSString*)set where:(NSString*)where completion:(void(^)(BOOL result))completion;

-(void)dropTable:(NSString*)tableName completion:(void(^)(BOOL result))completion;

-(void)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames completion:(void(^)(BOOL result))completion;
-(void)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames columnTypes:(NSArray*)columnTypes completion:(void(^)(BOOL result))completion;

-(void)alterTable:(NSString*)preTableName renameTo:(NSString*)tableName completion:(void(^)(BOOL result))completion;

-(void)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName completion:(void(^)(BOOL result))completion;
-(void)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName columnType:(NSString*)columnType completion:(void(^)(BOOL result))completion;

-(void)pragmaTableInfo:(NSString*)tableName completion:(void(^)(NSArray* results))completion;

-(void)compactDatabaseWithcompletion:(void(^)(BOOL result))completion;

@end