#import "YTGradientView.h"

@implementation YTGradientView

@dynamic colors;
@dynamic locations;
@dynamic startPoint;
@dynamic endPoint;

-(CAGradientLayer*)gradientLayer{
	return (CAGradientLayer*)self.layer;
}

+(Class)layerClass{
	return [CAGradientLayer class];
}

-(NSArray*)colors{
	return self.gradientLayer.colors;
}
-(void)setColors:(NSArray *)colors{
	self.gradientLayer.colors = colors;
}

-(NSArray*)locations{
	return self.gradientLayer.locations;
}
-(void)setLocations:(NSArray *)locations{
	self.gradientLayer.locations = locations;
}

-(CGPoint)startPoint{
	return self.gradientLayer.startPoint;
}
-(void)setStartPoint:(CGPoint)startPoint{
	self.gradientLayer.startPoint = startPoint;
}

-(CGPoint)endPoint{
	return self.gradientLayer.endPoint;
}
-(void)setEndPoint:(CGPoint)endPoint{
	self.gradientLayer.endPoint = endPoint;
}

@end