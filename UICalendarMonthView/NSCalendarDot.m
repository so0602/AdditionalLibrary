#import "NSCalendarDot.h"

@implementation NSCalendarDot

@synthesize color, size;

-(id)initWithColor:(UIColor*)aColor size:(float)aSize{
	if( self = [super init] ){
		self.color = aColor;
		self.size = aSize;
	}
	return self;
}

+(NSCalendarDot*)dotWithColor:(UIColor*)aColor size:(float)aSize{
	return [[[NSCalendarDot alloc] initWithColor:aColor size:aSize] autorelease];
}

#pragma mark Memory Management

-(void)dealloc{
	[color release], color = nil;
	size = 0.0;
	[super dealloc];
}

@end