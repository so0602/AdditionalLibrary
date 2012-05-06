#import "YTBoldLabel.h"

#define WIDTH 2
#define SIZE 17.0
#define LABEL_MAX_COUNT 9

@interface YTBoldLabel ()

-(void)initImpl;

@end

@implementation YTBoldLabel

@dynamic text, textColor;

-(id)initWithCoder:(NSCoder*)aDecoder{
	if( self = [super initWithCoder:aDecoder] ){
		[self initImpl];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame{
	if( self = [super initWithFrame:frame] ){
		[self initImpl];
	}
	return self;
}

-(NSString*)text{
	return labels[0].text;
}

-(void)setText:(NSString*)aText{
	for( int i = 0; i < LABEL_MAX_COUNT; i++ ){
		labels[i].text = aText;
	}
}

-(UIColor*)textColor{
	return labels[4].textColor;
}

-(void)setTextColor:(UIColor*)aTextColor{
	labels[4].textColor = aTextColor;
}

#pragma mark Private Functions

-(void)initImpl{
	self.backgroundColor = ClearColor();
	for( int i = 0; i < LABEL_MAX_COUNT; i ++ ){
		int dx = (i % 3 - 1) * WIDTH;
		int dy = (i / 3 - 1) * WIDTH;
		CGRect rect = CGRectMake(dx, dy, self.width, self.height);
		labels[i] = [[UILabel alloc] initWithFrame:rect font:[UIFont boldSystemFontOfSize:SIZE] textColor:WhiteColor() backgroundColor:ClearColor() textAlignment:UITextAlignmentCenter];
		labels[i].adjustsFontSizeToFitWidth = TRUE;
		if( i == 4 ) labels[i].textColor = DarkGrayColor();
		else [self addSubview:labels[i]];
	}
	
	[self addSubview:labels[4]];	
}

#pragma mark Memory Management

-(void)dealloc{
	for( int i = 0; i < LABEL_MAX_COUNT; i++ ){
		[labels[i] removeFromSuperview];
		[labels[i] release], labels[i] = nil;
	}
	[super dealloc];
}

@end