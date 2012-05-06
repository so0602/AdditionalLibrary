#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (Addition)

-(void)setValuesForKeyWithDictionary:(NSDictionary*)dictionary;
-(void)safeSetValuesForKeyWithDictionary:(NSDictionary*)dictionary;
-(void)safeSetValuesForKeyWithDictionary:(NSDictionary*)dictionary dateFormatter:(NSDateFormatter*)dateFormatter;

@end