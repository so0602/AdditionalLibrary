#import "NSURL+Addition.h"

@implementation NSURL (Addition)

-(NSDictionary*)parameters{
	NSString* urlString = [self absoluteString];
	NSArray* items = [urlString componentsSeparatedByString:@"?"];
	if( items.count != 2 ) return nil;
	
	urlString = [items objectAtIndex:1];
	items = [urlString componentsSeparatedByString:@"&"];
	if( items.count == 0 ) return nil;
	
	NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
	for( NSString* str in items ){
		NSArray* field = [str componentsSeparatedByString:@"="];
		[parameters setObject:[field objectAtIndex:1] forKey:[field objectAtIndex:0]];
	}
	
	return parameters;
}

@end