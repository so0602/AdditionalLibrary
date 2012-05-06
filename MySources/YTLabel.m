#import "YTLabel.h"

@interface YTLabel ()

-(void)setDefaults;

-(void)getComponents:(CGFloat*)rgba forColor:(CGColorRef)color;
-(CGColorRef)color:(CGColorRef)a blendedWithColor:(CGColorRef)b;

@end

@implementation YTLabel

#pragma mark - Override Functions

-(id)initWithFrame:(CGRect)frame{
	if( self = [super initWithFrame:frame] ){
		self.backgroundColor = nil;
		[self setDefaults];
	}
	return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder{
	if( self = [super initWithCoder:aDecoder] ){
		[self setDefaults];
	}
	return self;
}

-(void)setShadowBlurValue:(CGFloat)blur{
	if( _shadowBlurValue != blur ){
		_shadowBlurValue = blur;
		[self setNeedsDisplay];
	}
}

-(void)setInnerShadowOffset:(CGSize)offset{
	if( !CGSizeEqualToSize(_innerShadowOffset, offset) ){
		_innerShadowOffset = offset;
		[self setNeedsDisplay];
	}
}

-(void)setInnerShadowColor:(UIColor*)color{
	if( _innerShadowColor != color ){
		[_innerShadowColor release];
		_innerShadowColor = [color retain];
		[self setNeedsDisplay];
	}
}

-(void)setGradientStartColor:(UIColor*)color{
	if( _gradientStartColor != color ){
		[_gradientStartColor release];
		_gradientStartColor = [color retain];
		[self setNeedsDisplay];
	}
}

-(void)setGradientEndColor:(UIColor*)color{
	if( _gradientEndColor != color ){
		[_gradientEndColor release];
		_gradientEndColor = [color retain];
		[self setNeedsDisplay];
	}
}

-(void)setGradientStartPoint:(CGPoint)point{
	if( !CGPointEqualToPoint(_gradientStartPoint, point) ){
		_gradientStartPoint = point;
		[self setNeedsDisplay];
	}
}

-(void)setGradientEndPoint:(CGPoint)point{
	if( !CGPointEqualToPoint(_gradientEndPoint, point) ){
		_gradientEndPoint = point;
		[self setNeedsDisplay];
	}
}

-(CGColorRef)color:(CGColorRef)a blendedWithColor:(CGColorRef)b{
	CGFloat aRGBA[4];
	[self getComponents:aRGBA forColor:a];
	if( aRGBA[3] == 1.0f ){
		return [UIColor colorWithRed:aRGBA[0] green:aRGBA[1] blue:aRGBA[2] alpha:aRGBA[3]].CGColor;
	}
	
	CGFloat bRGBA[4];
	[self getComponents:bRGBA forColor:b];
	CGFloat source = aRGBA[3];
	CGFloat dest = 1.0f - source;
	return [UIColor colorWithRed:source * aRGBA[0] + dest * bRGBA[0] 
												 green:source * aRGBA[1] + dest * bRGBA[1] 
													blue:source * aRGBA[2] + dest * bRGBA[2] 
												 alpha:bRGBA[3] + (1.0f - bRGBA[3]) * aRGBA[3]].CGColor;
}

#pragma mark - Private Functions

-(void)setDefaults{
	_gradientStartPoint = CGPointMake(0.5f, 0.0f);
	_gradientEndPoint = CGPointMake(0.5f, 0.75f);
}

-(void)getComponents:(CGFloat*)rgba forColor:(CGColorRef)color{
	CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace(color));
	const CGFloat* components = CGColorGetComponents(color);
	switch( model ){
		case kCGColorSpaceModelMonochrome:
		{
			rgba[0] = components[0];
			rgba[1] = components[0];
			rgba[2] = components[0];
			rgba[3] = components[1];
			break;
		}
		case kCGColorSpaceModelRGB:
		{
			rgba[0] = components[0];
			rgba[1] = components[1];
			rgba[2] = components[2];
			rgba[3] = components[3];
			break;
		}
		default:
		{
			NSLog(@"Unsupported gradient color format: %i", model);
			rgba[0] = 0.0f;
			rgba[1] = 0.0f;
			rgba[2] = 0.0f;
			rgba[3] = 1.0f;
			break;
		}
	}
}

#pragma mark - UIView

-(void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect textRect = rect;
	CGFloat fontSize = self.font.pointSize;
	if( self.adjustsFontSizeToFitWidth ){
		textRect.size = [self.text sizeWithFont:self.font minFontSize:self.minimumFontSize actualFontSize:&fontSize forWidth:rect.size.width lineBreakMode:self.lineBreakMode];
	}else{
		textRect.size = [self.text sizeWithFont:self.font forWidth:rect.size.width lineBreakMode:self.lineBreakMode];
	}
	
	UIFont* font = [self.font fontWithSize:fontSize];
	
	switch( self.textAlignment ){
		case UITextAlignmentCenter:
		{
			textRect.origin.x = (rect.size.width - textRect.size.width) / 2.0f;
			break;
		}
		case UITextAlignmentRight:
		{
			textRect.origin.x = rect.size.width - textRect.size.width;
			break;
		}
		default:
			break;
	}
	
	switch( self.contentMode ){
		case UIViewContentModeTop:
		case UIViewContentModeTopLeft:
		case UIViewContentModeTopRight:
		{
			textRect.origin.y = 0.0f;
			break;
		}
		case UIViewContentModeBottom:
		case UIViewContentModeBottomLeft:
		case UIViewContentModeBottomRight:	
		{
			textRect.origin.y = rect.size.height - textRect.size.height;
			break;
		}
		default:
		{
			textRect.origin.y = (rect.size.height - textRect.size.height) / 2.0f;
			break;
		}
	}
	
	BOOL hasShadow = self.shadowColor && ![self.shadowColor isEqual:[UIColor clearColor]] && (self.shadowBlurValue > 0.0f || !CGSizeEqualToSize(self.shadowOffset, CGSizeZero));
	
	BOOL hasInnerShadow = self.innerShadowColor && ![self.innerShadowColor isEqual:[UIColor clearColor]] && !CGSizeEqualToSize(self.innerShadowOffset, CGSizeZero);
	
	BOOL hasGradient = self.gradientStartColor && self.gradientEndColor;
	
	BOOL needsMask = hasInnerShadow || hasGradient;
	
	CGImageRef alphaMask = NULL;
	if( needsMask ){
		CGContextSaveGState(context);
		[self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
		CGContextRestoreGState(context);
		
		alphaMask = CGBitmapContextCreateImage(context);
		
		CGContextClearRect(context, textRect);
	}
	
	if( hasShadow ){
		CGContextSaveGState(context);
		CGFloat textAlpha = CGColorGetAlpha(self.textColor.CGColor);
		CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlurValue, self.shadowColor.CGColor);
		[needsMask ? [self.shadowColor colorWithAlphaComponent:textAlpha] : self.textColor setFill];
		[self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
		CGContextRestoreGState(context);
	}
	
	if( needsMask ){
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, 0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		CGContextClipToMask(context, rect, alphaMask);
		
		if( hasInnerShadow ){
			[self.innerShadowColor setFill];
			CGContextFillRect(context, textRect);
			
			CGContextTranslateCTM(context, self.innerShadowOffset.width, -self.innerShadowOffset.height);
			CGContextClipToMask(context, rect, alphaMask);
		}
		
		if( hasGradient ){
			CGColorRef startColor = [self color:self.gradientStartColor.CGColor blendedWithColor:self.textColor.CGColor];
			CGColorRef endColor = [self color:self.gradientEndColor.CGColor blendedWithColor:self.textColor.CGColor];
			
			CGContextScaleCTM(context, 1.0, -1.0);
			CGContextTranslateCTM(context, 0, -rect.size.height);
			CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
			CGGradientRef gradient = CGGradientCreateWithColors(NULL, colors, NULL);
			CGPoint startPoint = CGPointMake(textRect.origin.x + self.gradientStartPoint.x * textRect.size.width, textRect.origin.y + self.gradientStartPoint.y * textRect.size.height);
			CGPoint endPoint = CGPointMake(textRect.origin.x + self.gradientEndPoint.x * textRect.size.width, textRect.origin.y + self.gradientEndPoint.y * textRect.size.height);
			CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
			CGGradientRelease(gradient);
		}else{
			[self.textColor setFill];
			CGContextFillRect(context, textRect);
		}
		
		CGContextRestoreGState(context);
		CGImageRelease(alphaMask);
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	[_innerShadowColor release];
	[_gradientStartColor release];
	[_gradientEndColor release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize shadowBlurValue = _shadowBlurValue;
@synthesize innerShadowOffset = _innerShadowOffset;
@synthesize innerShadowColor = _innerShadowColor;
@synthesize gradientStartColor = _gradientStartColor;
@synthesize gradientEndColor = _gradientEndColor;
@synthesize gradientStartPoint = _gradientStartPoint;
@synthesize gradientEndPoint = _gradientEndPoint;

@end