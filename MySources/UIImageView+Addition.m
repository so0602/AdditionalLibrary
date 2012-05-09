#import "UIImageView+Addition.h"

@implementation UIImageView (Addition)

-(id)initWithFrame:(CGRect)frame image:(UIImage*)image{
	if( self = [super initWithFrame:frame] ){
		self.image = image;
	}
	return self;
}

-(id)initWithDataSource:(id<YTUIImageViewDataSource>)dataSource{
	if( self = [super initWithDataSource:dataSource] ){
		
	}
	return self;
}

+(id)imageViewWithImage:(UIImage*)image{
	CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
	return [self imageViewWithFrame:frame image:image];
}

+(id)imageViewWithFrame:(CGRect)frame image:(UIImage*)image{
	return [[[self alloc] initWithFrame:frame image:image] autorelease];
}

+(id)imageViewWithDataSource:(id<YTUIImageViewDataSource>)dataSource{
	return [[[self alloc] initWithDataSource:dataSource] autorelease];
}

-(void)setAnimationDataSource:(id<YTUIAnimationImageDataSource>)dataSource{
	self.animationImages = [dataSource animationImages:self];
	if( RespondsToSelector(dataSource, @selector(highlightedAnimationImages:)) ) self.highlightedAnimationImages = [dataSource highlightedAnimationImages:self];
	if( RespondsToSelector(dataSource, @selector(animationDuration:)) ) self.animationDuration = [dataSource animationDuration:self];
	else self.animationDuration = self.animationImages.count / 30.f;
	if( RespondsToSelector(dataSource, @selector(animationRepeatCount:)) ) self.animationRepeatCount = [dataSource animationRepeatCount:self];
	else self.animationRepeatCount = 0;
}

#pragma mark Override Functions

-(void)setDataSource:(id<YTUIImageViewDataSource>)dataSource{
	[super setDataSource:dataSource];
	
	if( RespondsToSelector(dataSource, @selector(image:)) ){
		self.image = [dataSource image:self];
		if( !RespondsToSelector(dataSource, @selector(frame:)) && self.image ){
			self.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
		}
	}
	if( RespondsToSelector(dataSource, @selector(highlightedImage:)) ) self.highlightedImage = [dataSource highlightedImage:self];
	if( RespondsToSelector(dataSource, @selector(animationImageDataSource:)) ) [self setAnimationDataSource:[dataSource animationImageDataSource:self]];
}

-(void)stretchableImageByCenter{
	self.image = self.image.stretchableImageByCenter;
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTUIImageViewDataSource

@implementation YTUIImageViewDataSource

@synthesize image = _image;
@synthesize highlightedImage = _highlightedImage;
@synthesize animationImageDataSource = _animationImageDataSource;

-(UIImage*)image:(id)target{
	return self.image;
}

-(UIImage*)highlightedImage:(id)target{
	return self.highlightedImage;
}

-(id<YTUIAnimationImageDataSource>)animationImageDataSource:(id)target{
	return self.animationImageDataSource;
}

#pragma mark Memory Management

-(void)dealloc{
	self.image = nil;
	self.highlightedImage = nil;
	self.animationImageDataSource = nil;
	
	[super dealloc];
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTUIAnimationImageDataSource

@implementation YTUIAnimationImageDataSource

@synthesize animationImages = _animationImages;
@synthesize highlightedAnimationImages = _highlightedAnimationImages;
@synthesize animationDuration = _animationDuration;
@synthesize animationRepeatCount = _animationRepeatCount;

-(NSArray*)animationImages:(id)target{
	return self.animationImages;
}

-(NSArray*)highlightedAnimationImages:(id)target{
	return self.highlightedAnimationImages;
}

-(NSTimeInterval)animationDuration:(id)target{
	return self.animationDuration;
}

-(NSInteger)animationRepeatCount:(id)target{
	return self.animationRepeatCount;
}

#pragma mark Memory Management

-(void)dealloc{
	self.animationImages = nil;
	self.highlightedAnimationImages = nil;
	self.animationDuration = 0.0f;
	self.animationRepeatCount = 0;
	
	[super dealloc];
}

@end