#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "YTGlobalValues.h"

@interface YTDatabase : NSObject<NSCopying>{
@private
	NSString *_databaseName;
	
	sqlite3 *_database;
	
	BOOL _printLog;
}

@property (nonatomic, copy) NSString* databaseName;
@property (nonatomic, assign) sqlite3 *database;
@property (nonatomic, assign) BOOL printLog; //Default TRUE

-(id)initWithName:(NSString*)name copyAtResource:(BOOL)isCopy;
-(id)initWithName:(NSString*)name copyAtResource:(BOOL)isCopy updateToLatest:(BOOL)updateToLatest; //Default updateToLatest: FALSE. If TRUE, should be compare by Resource's database

-(id)initWithResourceName:(NSString*)name;

+(id)databaseWithName:(NSString*)name copyAtResource:(BOOL)isCopy;

-(void)insertInto:(NSString*)tableName columns:(NSArray*)columns values:(NSArray*)values;

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

-(void)deleteAllFrom:(NSString*)tableName;
-(void)deleteFrom:(NSString*)tableName where:(NSString*)where;

-(void)update:(NSString*)tableName set:(NSString*)set;
-(void)update:(NSString*)tableName set:(NSString*)set where:(NSString*)where;

-(void)dropTable:(NSString*)tableName;

-(void)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames;
-(void)createTable:(NSString*)tableName columnNames:(NSArray*)columnNames columnTypes:(NSArray*)columnTypes;

-(void)alterTable:(NSString*)preTableName renameTo:(NSString*)tableName;

-(void)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName;
-(void)alterTable:(NSString*)tableName addColumnName:(NSString*)columnName columnType:(NSString*)columnType;

-(void)alterTable:(NSString*)tableName addColumnNames:(NSArray*)columnNames;
-(void)alterTable:(NSString*)tableName addColumnNames:(NSArray*)columnNames columnTypes:(NSArray*)columnTypes;

-(NSArray*)pragmaTableInfo:(NSString*)tableName;

-(void)compactDatabase;

-(void)closeDB;

@end