#import "MKMapView+Addition.h"

@implementation MKMapView (Addition)

-(void)removeAllAnnotations{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	{
		NSMutableArray* array = [NSMutableArray arrayWithArray:self.annotations];
		[array removeObject:self.userLocation];
		[self removeAnnotations:array];
	}
	[pool drain];
}

@end