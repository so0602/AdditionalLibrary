#import "HTMLNode+Addition.h"

@implementation HTMLNode (Addition)

-(HTMLNode*)aNode{
	return [self findChildTag:@"a"];
}

-(NSURL*)href{
	NSString* href = [self.aNode getAttributeNamed:@"href"];
	return [NSURL URLWithString:href];
}

@end