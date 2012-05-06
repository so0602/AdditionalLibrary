#import "NSDateFormatter+Addition.h"

@implementation NSDateFormatter (Addition)

-(id)initWithLocale:(NSLocale*)locale{
	return [self initWithLocale:locale dateFormat:nil];
}

-(id)initWithDateFormat:(NSString*)dateFormat{
	return [self initWithLocale:nil dateFormat:dateFormat];
}

-(id)initWithLocale:(NSLocale*)locale dateFormat:(NSString*)dateFormat{
	if( self = [self init] ){
		if( locale ) [self setLocale:locale];
		if( dateFormat ) [self setDateFormat:dateFormat];
	}
	return self;
}

+(id)dateFormatter{
	return [[[NSDateFormatter alloc] init] autorelease];
}

+(id)dateFormatterWithLocale:(NSLocale*)locale{
	return [NSDateFormatter dateFormatterWithLocale:locale dateFormat:nil];
}

+(id)dateFormatterWithDateFormat:(NSString*)dateFormat{
	return [NSDateFormatter dateFormatterWithLocale:nil dateFormat:dateFormat];
}

+(id)dateFormatterWithLocale:(NSLocale*)locale dateFormat:(NSString*)dateFormat{
	return [[[NSDateFormatter alloc] initWithLocale:locale dateFormat:dateFormat] autorelease];
}

@end