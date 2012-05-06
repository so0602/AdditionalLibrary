#import "NSLocale+Addition.h"

@implementation NSLocale (Addition)

+(id)zhHKLocale{
	return [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_HK"] autorelease];
}

@end