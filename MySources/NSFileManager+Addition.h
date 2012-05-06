#import <Foundation/Foundation.h>

#import "YTGlobalValues.h"

@interface NSFileManager (DocumentPath)

+(BOOL)fileExistsAtDocumentPath:(NSString*)path;
+(BOOL)removeItemAtDocumentPath:(NSString*)path error:(NSError**)error;
+(BOOL)renameItemAtDocumentPath:(NSString*)path toName:(NSString*)name error:(NSError**)error;

+(NSArray*)itemsAtDocumentPath:(NSString*)path contains:(NSString*)contains;
+(NSArray*)removeItemsAtDocumentPath:(NSString*)path contains:(NSString*)contains;

@end

@interface NSFileManager (CachedPath)

+(BOOL)fileExistsAtCachedPath:(NSString*)path;
+(BOOL)removeItemAtCachedPath:(NSString*)path error:(NSError**)error;
+(BOOL)renameItemAtCachedPath:(NSString*)path toName:(NSString*)name error:(NSError**)error;

+(NSArray*)itemsAtCachedPath:(NSString*)path contains:(NSString*)contains;
+(NSArray*)removeItemsAtCachedPath:(NSString*)path contains:(NSString*)contains;

@end