#import "UILabel+Addition.h"

@implementation UILabel (Addition)

-(id)initWithFrame:(CGRect)frame font:(UIFont*)font{
	return [self initWithFrame:frame font:font textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:UITextAlignmentLeft shadowColor:nil shadowOffset:CGSizeMake(1, 1) numberOfLines:1];
}

-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor{
	return [self initWithFrame:frame font:font textColor:textColor backgroundColor:[UIColor clearColor] textAlignment:UITextAlignmentLeft shadowColor:nil shadowOffset:CGSizeMake(1, 1) numberOfLines:1];
}

-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor{
	return [self initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor textAlignment:UITextAlignmentLeft shadowColor:nil shadowOffset:CGSizeMake(1, 1) numberOfLines:1];
}

-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment{
	return [self initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor textAlignment:textAlignment shadowColor:nil shadowOffset:CGSizeMake(1, 1) numberOfLines:1];
}

-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor{
	return [self initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor textAlignment:textAlignment shadowColor:shadowColor shadowOffset:CGSizeMake(1, 1) numberOfLines:1];
}

-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset{
	return [self initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor textAlignment:textAlignment shadowColor:shadowColor shadowOffset:shadowOffset numberOfLines:1];
}

-(id)initWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset numberOfLines:(NSInteger)numberOfLines{
	if( self = [self initWithFrame:frame] ){
		self.font = font;
		self.textColor = textColor;
		self.backgroundColor = backgroundColor;
		self.textAlignment = textAlignment;
		if( shadowColor ){
			self.shadowColor = shadowColor;
			self.shadowOffset = shadowOffset;
		}
		self.numberOfLines = numberOfLines;
	}
	return self;
}

-(id)initWithDataSource:(id<YTUILabelDataSource>)dataSource{
	if( self = [super initWithDataSource:dataSource] ){
	}
	return self;
}

+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font{
	return [[[self alloc] initWithFrame:frame font:font] autorelease];
}

+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor{
	return [[[self alloc] initWithFrame:frame font:font textColor:textColor] autorelease];
}

+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor{
	return [[[self alloc] initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor] autorelease];
}

+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment{
	return [[[self alloc] initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor textAlignment:textAlignment] autorelease];
}

+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor{
	return [[[self alloc] initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor textAlignment:textAlignment shadowColor:shadowColor] autorelease];
}

+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset{
	return [[[self alloc] initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor textAlignment:textAlignment shadowColor:shadowColor shadowOffset:shadowOffset] autorelease];
}

+(id)labelWithFrame:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor textAlignment:(UITextAlignment)textAlignment shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset numberOfLines:(NSInteger)numberOfLines{
	return [[[self alloc] initWithFrame:frame font:font textColor:textColor backgroundColor:backgroundColor textAlignment:textAlignment shadowColor:shadowColor shadowOffset:shadowOffset numberOfLines:numberOfLines] autorelease];
}

+(id)labelWithDataSource:(id<YTUILabelDataSource>)dataSource{
	return [[[self alloc] initWithDataSource:dataSource] autorelease];
}

-(void)sizeToFitWidth{
	int height = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 10000)].height;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

-(void)adjustsFontSizeToFitWidthForMultilines{
	CGFloat fontSize = self.font.pointSize;
	CGSize constrainedToSize = CGSizeMake(self.frame.size.width, 999999);
	CGFloat height = [self.text sizeWithFont:self.font constrainedToSize:constrainedToSize lineBreakMode:self.lineBreakMode].height;
	UIFont* newFont = self.font;
	
	while( height > self.frame.size.height && height != 0 ){
		fontSize--;
		newFont = [UIFont fontWithName:self.font.fontName size:fontSize];
		if( fontSize == self.minimumFontSize ){
			self.font = newFont;
			return;
		}
		height = [self.text sizeWithFont:newFont constrainedToSize:constrainedToSize lineBreakMode:self.lineBreakMode].height;
	}
	
	NSArray* words = [self.text componentsSeparatedByString:@" "];
	for( NSString* word in words ){
		CGFloat width = [word sizeWithFont:newFont].width;
		while( width > self.frame.size.width && width != 0 ){
			fontSize--;
			newFont = [UIFont fontWithName:self.font.fontName size:fontSize];
			if( fontSize == self.minimumFontSize ){
				self.font = newFont;
				return;
			}
			width = [word sizeWithFont:newFont].width;
		}
	}
	self.font = newFont;
}

-(NSInteger)visableNumberOfLines{
	int height = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 10000)].height;
	return height / self.font.lineHeight;
}

#pragma mark Override Functions

-(void)setDataSource:(id<YTUILabelDataSource>)dataSource{
	[super setDataSource:dataSource];
	if( RespondsToSelector(dataSource, @selector(font:)) ) self.font = [dataSource font:self];
	if( RespondsToSelector(dataSource, @selector(textColor:)) ) self.textColor = [dataSource textColor:self];
	if( RespondsToSelector(dataSource, @selector(textAlignment:)) ) self.textAlignment = [dataSource textAlignment:self];
	if( RespondsToSelector(dataSource, @selector(shadowColor:)) ){
		self.shadowColor = [dataSource shadowColor:self];
		if( RespondsToSelector(dataSource, @selector(shadowOffset:)) ) self.shadowOffset = [dataSource shadowOffset:self];
	}
	if( RespondsToSelector(dataSource, @selector(numberOfLines:)) ) self.numberOfLines = [dataSource numberOfLines:self];
}

@end

#pragma mark -
#pragma mark -
#pragma mark YTUILabelDataSource

@implementation YTUILabelDataSource

@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize textAlignment = _textAlignment;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize numberOfLines = _numberOfLines;

-(UIFont*)font:(id)taget{
	return self.font;
}

-(UIColor*)textColor:(id)taget{
	return self.textColor;
}

-(UITextAlignment)textAlignment:(id)taget{
	return self.textAlignment;
}

-(UIColor*)shadowColor:(id)taget{
	return self.shadowColor;
}

-(CGSize)shadowOffset:(id)taget{
	return self.shadowOffset;
}

-(NSInteger)numberOfLines:(id)taget{
	return self.numberOfLines;
}

#pragma mark Memory Management

-(void)dealloc{
	self.font = nil;
	self.textColor = nil;
	self.textAlignment = 0;
	self.shadowColor = nil;
	self.shadowOffset = CGSizeZero;
	self.numberOfLines = 0;
	
	[super dealloc];
}

@end