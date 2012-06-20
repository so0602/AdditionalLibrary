#import "HTMLNode+Addition.h"

@implementation HTMLNode (Addition)

-(HTMLNode*)aNode{
	return [self findChildTag:@"a"];
}

-(NSArray*)aNodes{
	return [self findChildTags:@"a"];
}

-(NSURL*)href{
	NSString* href = [self.aNode getAttributeNamed:@"href"];
	return [NSURL URLWithString:href];
}

-(HTMLNode*)liNode{
	return [self findChildTag:@"li"];
}

-(NSArray*)liNodes{
	return [self findChildTags:@"li"];
}

@end