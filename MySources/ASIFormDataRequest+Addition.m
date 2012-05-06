#import "ASIFormDataRequest+Addition.h"

@implementation ASIFormDataRequest (Addition)

-(NSMutableArray*)postData{
	return postData;
}

-(NSString*)urlForGetMethod{
	NSMutableString* urlForGetMethod = [NSMutableString stringWithFormat:@"%@?", [self.url absoluteString]];
	for( NSDictionary* dictionary in self.postData ){
		[urlForGetMethod appendFormat:@"%@=%@&", [dictionary objectForKey:@"key"], [dictionary objectForKey:@"value"]];
	}
	[urlForGetMethod replaceCharactersInRange:NSMakeRange(urlForGetMethod.length - 1, 1) withString:@""];
	return urlForGetMethod;
}

-(void)addPostValues:(NSDictionary*)postValues{
	if( !postValues ) return;
	
	for( NSString* key in postValues.allKeys ){
		NSString* value = [postValues objectForKey:key];
		[self addPostValue:value forKey:key];
	}
}

@end