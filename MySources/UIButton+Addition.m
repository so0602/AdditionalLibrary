#import "UIButton+Addition.h"

@implementation UIButton (Addition)

-(UIImage*)normalImage{
	return [self imageForState:UIControlStateNormal];
}
-(void)setNormalImage:(UIImage *)normalImage{
	[self setImage:normalImage forState:UIControlStateNormal];
}
-(UIImage*)normalBackgroundImage{
	return [self backgroundImageForState:UIControlStateNormal];
}
-(void)setNormalBackgroundImage:(UIImage *)normalBackgroundImage{
	[self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
}

-(UIImage*)highlightedImage{
	return [self imageForState:UIControlStateHighlighted];
}
-(void)setHighlightedImage:(UIImage *)highlightedImage{
	[self setImage:highlightedImage forState:UIControlStateHighlighted];
}
-(UIImage*)highlightedBackgroundImage{
	return [self backgroundImageForState:UIControlStateHighlighted];
}
-(void)setHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage{
	[self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

-(UIImage*)disabledImage{
	return [self imageForState:UIControlStateDisabled];
}
-(void)setDisabledImage:(UIImage *)disabledImage{
	[self setImage:disabledImage forState:UIControlStateDisabled];
}
-(UIImage*)disabledBackgroundImage{
	return [self backgroundImageForState:UIControlStateDisabled];
}
-(void)setDisabledBackgroundImage:(UIImage *)disabledBackgroundImage{
	[self setBackgroundImage:disabledBackgroundImage forState:UIControlStateDisabled];
}

-(UIImage*)selectedImage{
	return [self imageForState:UIControlStateSelected];
}
-(void)setSelectedImage:(UIImage *)selectedImage{
	[self setImage:selectedImage forState:UIControlStateSelected];
}
-(UIImage*)selectedBackgroundImage{
	return [self backgroundImageForState:UIControlStateSelected];
}
-(void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage{
	[self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
}

+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title{
	return [UIButton buttonWithType:buttonType title:title titleColor:nil font:nil image:nil backgroundImage:nil];
}

+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title titleColor:(UIColor*)titleColor{
	return [UIButton buttonWithType:buttonType title:title titleColor:titleColor font:nil image:nil backgroundImage:nil];
}

+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font{
	return [UIButton buttonWithType:buttonType title:title titleColor:titleColor font:font image:nil backgroundImage:nil];
}

+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font image:(UIImage*)image{
	return [UIButton buttonWithType:buttonType title:title titleColor:titleColor font:font image:image backgroundImage:nil];
}

+(id)buttonWithType:(UIButtonType)buttonType title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font image:(UIImage*)image backgroundImage:(UIImage*)backgroundImage{
	UIButton* button = [[UIButton buttonWithType:buttonType] retain];
	[button setFont:font];
	[button setTitle:title titleColor:titleColor image:image backgroundImage:backgroundImage forState:UIControlStateNormal];
	return [button autorelease];
}

+(id)buttonWithType:(UIButtonType)buttonType dataSourceList:(id<YTUIButtonDataSourceList>)dataSourceList{
	UIButton* button = [[UIButton buttonWithType:buttonType] retain];
	[button setDataSourceList:dataSourceList];
	return [button autorelease];
}

-(void)setTitle:(NSString*)title titleColor:(UIColor*)titleColor image:(UIImage*)image backgroundImage:(UIImage*)backgroundImage forState:(UIControlState)state{
	if( title ) [self setTitle:title forState:state];
	if( titleColor ) [self setTitleColor:titleColor forState:state];
	if( image ) [self setImage:image forState:state];
	if( backgroundImage ) [self setBackgroundImage:backgroundImage forState:state];
}

-(void)setFont:(UIFont*)font{
	self.titleLabel.font = font;
}

-(void)setDataSource:(id<YTUIButtonDataSource>)dataSource{
	NSString* title = nil;
	UIColor* titleColor = nil;
	UIImage* image = nil;
	UIImage* backgroundImage = nil;
	
	if( RespondsToSelector(dataSource, @selector(title:)) ) title = [dataSource title:self];
	if( RespondsToSelector(dataSource, @selector(titleColor:)) ) titleColor = [dataSource titleColor:self];
	if( RespondsToSelector(dataSource, @selector(image:)) ) image = [dataSource image:self];
	if( RespondsToSelector(dataSource, @selector(backgroundImage:)) ) backgroundImage = [dataSource backgroundImage:self];
	
	[self setTitle:title titleColor:titleColor image:image backgroundImage:backgroundImage forState:[dataSource state:self]];
}

-(void)setDataSourceList:(id<YTUIButtonDataSourceList>)dataSourceList{
	[super setDataSource:dataSourceList];
	if( RespondsToSelector(dataSourceList, @selector(font:)) ) [self setFont:[dataSourceList font:self]];
	for( id<YTUIButtonDataSource> dataSource in [dataSourceList dataSources:self] ) [self setDataSource:dataSource];
}

-(void)stretchableImageByCenter{
	UIImage* image = [self backgroundImageForState:UIControlStateNormal];
	if( image ) [self setBackgroundImage:image.stretchableImageByCenter forState:UIControlStateNormal];
	
	image = [self backgroundImageForState:UIControlStateSelected];
	
	if( image && [NSStringFromClass(image.class) isEqualToString:NSStringFromClass(UIImage.class)] ) [self setBackgroundImage:image.stretchableImageByCenter forState:UIControlStateSelected];
	
	image = [self backgroundImageForState:UIControlStateHighlighted];
	if( image && [NSStringFromClass(image.class) isEqualToString:NSStringFromClass(UIImage.class)] ) [self setBackgroundImage:image.stretchableImageByCenter forState:UIControlStateHighlighted];
	
	image = [self backgroundImageForState:UIControlStateDisabled];
	if( image && [NSStringFromClass(image.class) isEqualToString:NSStringFromClass(UIImage.class)] ) [self setBackgroundImage:image.stretchableImageByCenter forState:UIControlStateDisabled];
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTUIButtonDataSource

@implementation YTUIButtonDataSource

@synthesize title = _title;
@synthesize titleColor = _titleColor;
@synthesize image = _image;
@synthesize backgroundImage = _backgroundImage;
@synthesize state = _state;

-(UIControlState)state:(id)target{
	return self.state;
}

-(NSString*)title:(id)target{
	return self.title;
}

-(UIColor*)titleColor:(id)target{
	return self.titleColor;
}

-(UIImage*)image:(id)target{
	return self.image;
}

-(UIImage*)backgroundImage:(id)target{
	return self.backgroundImage;
}

#pragma mark Memory Management

-(void)dealloc{
	self.title = nil;
	self.titleColor = nil;
	self.image = nil;
	self.backgroundImage = nil;
	self.state = 0;
	
	[super dealloc];
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTUIButtonDataSourceList

@implementation YTUIButtonDataSourceList

@synthesize font = _font;
@synthesize dataSources = _dataSources;

-(NSArray<YTUIButtonDataSource>*)dataSources:(id)target{
	return self.dataSources;
}

-(UIFont*)font:(id)target{
	return self.font;
}

#pragma mark Memory Management

-(void)dealloc{
	self.font = nil;
	self.dataSources = nil;
	
	[super dealloc];
}

@end