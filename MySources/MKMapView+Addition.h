#import <MapKit/MapKit.h>

@interface MKMapView (Addition)

-(void)removeAllAnnotations; //With out User Location

@end

@interface MKMapView (ZoomLevel)

-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

@end