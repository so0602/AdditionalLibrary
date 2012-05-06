#import <CoreLocation/CoreLocation.h>

#import "YTDefineValues.h"

@interface CLLocation (SGAREnvironment)

-(id)initWithCLLocation:(CLLocation*)location;

+(id)locationWithCLLocation:(CLLocation*)location;
+(id)locationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

-(BOOL)isEqualToLocation:(CLLocation*)location;

-(double)bearingFromCoordinate:(CLLocationCoordinate2D)coord;

@end
	
CLLocation* CLLocationFromString(NSString* string);
NSString* NSStringFromCLLocation(CLLocation* location);