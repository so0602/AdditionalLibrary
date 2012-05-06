#import "YTDefineValues.h"

@interface NSDateFormatter (Addition)

-(id)initWithLocale:(NSLocale*)locale;
-(id)initWithDateFormat:(NSString*)dateFormat;

-(id)initWithLocale:(NSLocale*)locale dateFormat:(NSString*)dateFormat;

+(id)dateFormatter;

+(id)dateFormatterWithLocale:(NSLocale*)locale;
+(id)dateFormatterWithDateFormat:(NSString*)dateFormat;

+(id)dateFormatterWithLocale:(NSLocale*)locale dateFormat:(NSString*)dateFormat;

@end