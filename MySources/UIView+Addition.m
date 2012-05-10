#import "UIView+Addition.h"

@interface UIView ()

@property (nonatomic, readonly) NSString* currentText;
@property (nonatomic, readonly) NSNumberFormatter* numberFormatter;

-(void)setButtonExclusiveTouch:(BOOL)buttonExclusiveTouch superview:(UIView*)superview;

@end

@implementation UIView (Addition)

-(id)initWithDataSource:(id<YTUIViewDataSource>)dataSource{
	if( self = [self initWithFrame:CGRectZero] ){
		[self setDataSource:dataSource];
	}
	return self;
}

+(id)viewWithFrame:(CGRect)frame{
	return [[[self alloc] initWithFrame:frame] autorelease];
}

+(id)viewWithDataSource:(id<YTUIViewDataSource>)dataSource{
	return [[[self alloc] initWithDataSource:dataSource] autorelease];
}

-(void)setDataSource:(id<YTUIViewDataSource>)dataSource{
	if( RespondsToSelector(dataSource, @selector(frame:)) ) self.frame = [dataSource frame:self];
	if( RespondsToSelector(dataSource, @selector(backgroundColor:)) ) self.backgroundColor = [dataSource backgroundColor:self];
}

#pragma mark -

-(void)stretchableImageByCenter{
}

-(void)sizeToFitAndSharp{
	[self sizeToFit];
	[self sharp];
}

-(void)sharp{
	self.frame = CGRectMake((int)self.frame.origin.x, (int)self.frame.origin.y, (int)self.frame.size.width, (int)self.frame.size.height);
}

-(void)moveViewWithLeftTop:(CGPoint)point{
	self.origin = point;
}

-(void)moveViewWithLeftBottom:(CGPoint)point{
	self.frame = CGRectMake(point.x, point.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

-(void)moveViewWithRightTop:(CGPoint)point{
	self.frame = CGRectMake(point.x-self.frame.size.width, point.y, self.frame.size.width, self.frame.size.height);
}

-(void)moveViewWithRightBottom:(CGPoint)point{
	self.frame = CGRectMake(point.x-self.frame.size.width, point.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

-(void)scaleViewWithSize:(CGSize)size{
	self.size = size;
}

-(void)scaleViewWithSize:(CGSize)size verticalAlignment:(AlignmentType)verticalAlignment horizontalAlignment:(AlignmentType)horizontalAlignment{
	CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
	
	switch( verticalAlignment + horizontalAlignment ){
		case AlignmentTypeCenter + AlignmentTypeCenter:
			rect.origin.x = self.center.x - size.width / 2;
			rect.origin.y = self.center.y - size.height / 2;
			break;
		case AlignmentTypeTop + AlignmentTypeCenter:
			rect.origin.x = self.center.x - size.width / 2;
			break;
		case AlignmentTypeBottom + AlignmentTypeCenter:
			rect.origin.x = self.center.x - size.width / 2;
			rect.origin.y = self.maxY - size.height;
			break;
		case AlignmentTypeCenter + AlignmentTypeLeft:
			rect.origin.y = self.maxY - size.height;
			break;
		case AlignmentTypeTop + AlignmentTypeLeft:
			break;
		case AlignmentTypeBottom + AlignmentTypeLeft:
			rect.origin.y = self.maxY - size.height;
			break;
		case AlignmentTypeCenter + AlignmentTypeRight:
			rect.origin.x = self.maxX - size.width;
			rect.origin.y = self.center.y - size.height / 2;
			break;
		case AlignmentTypeTop + AlignmentTypeRight:
			rect.origin.x = self.maxX - size.width;
			break;
		case AlignmentTypeBottom + AlignmentTypeRight:
			rect.origin.x = self.maxX - size.width;
			rect.origin.y = self.maxY - size.height;
			break;			
	}
	self.frame = rect;
}

-(void)scaleViewWithScaleFactor:(float)aScaleFactor{
	[self scaleViewWithSize:CGSizeMake((int)(self.frame.size.width * aScaleFactor), (int)(self.frame.size.height * aScaleFactor))];
}

-(void)contentsScaleToFit{
	if( IsIPad() ) self.layer.contentsScale = 2.0f;
}

-(void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius{
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	
	if( radius == 0 ){
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextAddRect(context, rect);
	}else{
		rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
		CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
		CGContextScaleCTM(context, radius, radius);
		float fw = CGRectGetWidth(rect) / radius;
		float fh = CGRectGetHeight(rect) / radius;
		
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	}
	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

-(void)drawRect:(CGRect)rect fill:(const CGFloat *)fillColors radius:(CGFloat)radius{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	if( fillColors ){
		CGContextSaveGState(context);
		CGContextSetFillColor(context, fillColors);
		if( radius ){
			[self addRoundedRectToPath:context rect:rect radius:radius];
			CGContextFillPath(context);
		}else CGContextFillRect(context, rect);
		CGContextRestoreGState(context);
	}
	CGColorSpaceRelease(space);
}

-(void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(context);
	CGContextSetStrokeColorSpace(context, space);
	CGContextSetStrokeColor(context, strokeColor);
	CGContextSetLineWidth(context, 1.0);
	
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y-0.5, rect.origin.x+rect.size.width, rect.origin.y-0.5};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5, rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+rect.size.width-0.5, rect.origin.y, rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y, rect.origin.x+0.5, rect.origin.y+rect.size.height};
		CGContextStrokeLineSegments(context, points, 2);
	}
	
	CGContextRestoreGState(context);
	CGColorSpaceRelease(space);
}

-(void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor radius:(CGFloat)radius{
	if( radius ){
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		
		if( strokeColor ){
			CGContextSaveGState(context);
			CGContextSetFillColor(context, strokeColor);
			[self addRoundedRectToPath:context rect:rect radius:radius];
			CGContextStrokePath(context);
			CGContextRestoreGState(context);
		}
		CGColorSpaceRelease(space);
	}else [self strokeLines:rect stroke:strokeColor];
}

-(void)addSubviews:(UIView*)firstView, ...{
	UIView* eachView = nil;
	va_list argumentList;
	if( firstView ){
		[self addSubview:firstView];
		va_start(argumentList, firstView);
		while( (eachView = va_arg(argumentList, UIView*)) ){
			[self addSubview:eachView];
		}
		va_end(argumentList);
	}
}

-(void)disableUserInteraction{
	self.userInteractionEnabled = FALSE;
}

-(void)enableUserInteraction{
	self.userInteractionEnabled = TRUE;
}

-(BOOL)buttonExclusiveTouch{
	return FALSE;
}
-(void)setButtonExclusiveTouch:(BOOL)buttonExclusiveTouch{
	[self setButtonExclusiveTouch:buttonExclusiveTouch superview:self];
}

#pragma mark - Private Functions

-(void)setButtonExclusiveTouch:(BOOL)buttonExclusiveTouch superview:(UIView*)superview{
	for( UIView* subview in superview.subviews ){
		if( [subview isMemberOfClass:UIButton.class] || [subview isKindOfClass:UIButton.class] ){
			((UIButton*)subview).exclusiveTouch = buttonExclusiveTouch;
		}else if( [subview isKindOfClass:UIView.class] ){
			[self setButtonExclusiveTouch:buttonExclusiveTouch superview:subview];
		}
	}
}

#pragma mark -

-(float)minX{
	return CGRectGetMinX(self.frame);
}

-(float)minY{
	return CGRectGetMinY(self.frame);
}

-(float)maxX{
	return CGRectGetMaxX(self.frame);
}

-(float)maxY{
	return CGRectGetMaxY(self.frame);
}

-(float)halfWidth{
	return self.width / 2;
}

-(float)halfHeight{
	return self.height / 2;
}

-(float)x{
	return self.minX;
}

-(void)setX:(float)x{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

-(float)y{
	return self.minY;
}

-(void)setY:(float)y{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

-(float)width{
	return self.frame.size.width;
}

-(void)setWidth:(float)width{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

-(float)height{
	return self.frame.size.height;
}

-(void)setHeight:(float)height{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

-(CGPoint)origin{
	return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin{
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

-(CGSize)size{
	return self.frame.size;
}

-(void)setSize:(CGSize)size{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

-(IBAction)click:(id)sender{
}

-(IBAction)languageDidChanged{
}

-(IBAction)didReceiveMemoryWarning{
}

+(id)loadNib{
	return [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] lastObject];
}

-(BOOL)disable{
	return self.alpha == 1.0 && self.userInteractionEnabled;
}

-(void)setDisable:(BOOL)aDisable{
	switch( aDisable ){
		case FALSE:
			self.alpha = 1.0;
			self.userInteractionEnabled = TRUE;
			break;
		case TRUE:
			self.alpha = 0.7;
			self.userInteractionEnabled = FALSE;
			break;
	}
}

-(NSString*)dollarText{
	if( self.currentText.length == 0 ) return nil;
	NSArray* array = [self.currentText componentsSeparatedByString:@"."];
	NSString* decimalStr = nil;
	if( array.count > 2 ) return nil;
	else if( array.count == 2 ) decimalStr = [array objectAtIndex:1];
	
	NSNumber* number = [NSNumber numberWithInt:[self.textNumber doubleValue]];
	NSString* convertedString = [self.numberFormatter stringFromNumber:number];
	if( decimalStr ) return [NSString stringWithFormat:@"%@.%@", convertedString, decimalStr];
	if( !convertedString ) return @"";
	return convertedString;
}

-(NSNumber*)textNumber{
	if( self.currentText.length == 0 ) return nil;
	
	return [self.numberFormatter numberFromString:self.currentText];
}

#pragma mark Private Functions

-(NSString*)currentText{
	SEL selector = @selector(text);
	if( !RespondsToSelector(self, selector) ) return nil;
	return [self performSelector:selector];
}

-(NSNumberFormatter*)numberFormatter{
	NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setGroupingSeparator:@","];
	[formatter setGroupingSize:3];
	[formatter setUsesGroupingSeparator:TRUE];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	return formatter;
}

@end

@implementation YTUIViewDataSource

@synthesize backgroundColor = _backgroundColor;
@synthesize frame = _frame;

-(CGRect)frame:(id)target{
	return self.frame;
}

-(UIColor*)backgroundColor:(id)target{
	return self.backgroundColor;
}

#pragma mark Memory Management

-(void)dealloc{
	self.backgroundColor = nil;
	self.frame = CGRectNull;
	
	[super dealloc];
}

@end