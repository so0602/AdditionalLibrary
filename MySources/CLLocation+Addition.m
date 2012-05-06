#import "CLLocation+Addition.h"

@implementation CLLocation (SGAREnvironment)

-(id)initWithCLLocation:(CLLocation*)location{
	return [self initWithCoordinate:location.coordinate altitude:location.altitude horizontalAccuracy:location.horizontalAccuracy verticalAccuracy:location.verticalAccuracy timestamp:location.timestamp];
}

+(id)locationWithCLLocation:(CLLocation*)location{
	return [[[CLLocation alloc] initWithCLLocation:location] autorelease];
}

+(id)locationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
	return [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
}

-(BOOL)isEqualToLocation:(CLLocation *)location{
	BOOL locationsAreEqual = TRUE;
	if( location ){
		locationsAreEqual &= location.coordinate.latitude == self.coordinate.latitude;
		locationsAreEqual &= location.coordinate.longitude == self.coordinate.longitude;
	}
	return locationsAreEqual;
}

-(double)bearingFromCoordinate:(CLLocationCoordinate2D)coord{
	CLLocationCoordinate2D first = self.coordinate;
	CLLocationCoordinate2D second = coord;
	
	double deltaLong = first.longitude - second.longitude;
	
	double b = atan2( sin(deltaLong) * cos(second.latitude), cos(first.latitude) * sin(second.latitude) - sin(first.latitude) * cos(second.latitude) * cos(deltaLong) );
	return (b * 180.0 / M_PI);
}

@end

CLLocation* CLLocationFromString(NSString* string){
	NSMutableString* str = [NSMutableString stringWithString:string];
	if( ![str hasPrefix:@"{"] ) [str insertString:@"{" atIndex:0];
	if( ![str hasSuffix:@"}"] ) [str appendString:@"}"];
	
	CGPoint point = CGPointFromString(str);
	return [[[CLLocation alloc] initWithLatitude:point.x longitude:point.y] autorelease];
}

NSString* NSStringFromCLLocation(CLLocation* location){
	return [NSString stringWithFormat:@"{%f, %f}", location.coordinate.latitude, location.coordinate.longitude];
}