#import "YTProgressAlertView.h"

@interface YTProgressAlertView ()

@property (nonatomic, retain) UIProgressView* progressView;
@property (nonatomic, retain) UILabel* numberOfItemLabel;
@property (nonatomic, retain) UIActivityIndicatorView* indicatorView;
@property (nonatomic, assign) NSUInteger maxOfItems;
@property (nonatomic, assign) BOOL showNumber;

@end

@implementation YTProgressAlertView

-(id)initWithTitle:(NSString*)title message:(NSString*)message maxOfItems:(NSUInteger)maxOfItems showNumber:(BOOL)showNumber{
	if( self = [super initWithTitle:title message:[NSString stringWithFormat:@"%@\n\n\n", message.length == 0 ? @"" : message] delegate:self cancelButtonTitle:nil otherButtonTitles:nil] ){
		[self addSubview:self.progressView];
		[self addSubview:self.numberOfItemLabel];
		[self addSubview:self.indicatorView];
		
		self.showNumber = showNumber;
		self.maxOfItems = maxOfItems;
	}
	return self;
}

+(id)showWithTitle:(NSString*)title message:(NSString*)message maxOfItems:(NSUInteger)maxOfItems showNumber:(BOOL)showNumber{
	YTProgressAlertView* alertView = [[YTProgressAlertView alloc] initWithTitle:title message:message maxOfItems:maxOfItems showNumber:showNumber];
	[alertView show];
	return [alertView autorelease];
}

-(void)show{
	[super show];
	
	UILabel* label = nil;
	for( UILabel* view in self.subviews ){
		if( ![view isKindOfClass:[UILabel class]] ) continue;
		if( [view.text isEqualToString:self.message] ){
			label = view;
			break;
		}
	}
	self.indicatorView.center = CGPointMake(self.halfWidth - self.indicatorView.halfWidth + self.x, 0);
	self.indicatorView.y = label.maxY - 25;
	self.progressView.y = self.indicatorView.maxY + 8;
	if( self.showNumber ){
		self.numberOfItemLabel.y = self.progressView.y + 15;
	}
}

#pragma mark Private Functions

-(UIProgressView*)progressView{
	if( !_progressView ){
		_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		_progressView.frame = CGRectMake(91, 60, 100, _progressView.height);
	}
	return _progressView;
}

-(UILabel*)numberOfItemLabel{
	if( !_numberOfItemLabel ){
		_numberOfItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, self.progressView.maxY + 5, 260, 20)];
		_numberOfItemLabel.font = [UIFont systemFontOfSize:14];
		_numberOfItemLabel.backgroundColor = ClearColor();
		_numberOfItemLabel.textColor = WhiteColor();
		_numberOfItemLabel.textAlignment = UITextAlignmentCenter;
	}
	return _numberOfItemLabel;
}

-(UIActivityIndicatorView*)indicatorView{
	if( !_indicatorView ){
		_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[_indicatorView startAnimating];
	}
	return _indicatorView;
}

-(void)setNumberOfItems:(NSUInteger)numberOfItems{
	_numberOfItems = numberOfItems;
	self.progressView.progress = (float)_numberOfItems / _maxOfItems;
	if( self.showNumber ){
		self.numberOfItemLabel.text = [NSString stringWithFormat:@"%d / %d", _numberOfItems, _maxOfItems];
	}
}

-(void)setMaxOfItems:(NSUInteger)maxOfItems{
	_maxOfItems = maxOfItems;
	if( self.showNumber ){
		self.numberOfItemLabel.text = [NSString stringWithFormat:@"%d / %d", _numberOfItems, _maxOfItems];
	}
}

#pragma mark Memory Management

-(void)dealloc{
	if( _progressView ){
		[self.progressView removeFromSuperview];
		self.progressView = nil;
	}
	
	if( _numberOfItemLabel ){
		[self.numberOfItemLabel removeFromSuperview];
		self.numberOfItemLabel = nil;
	}
	
	if( _indicatorView ){
		[self.indicatorView removeFromSuperview];
		self.indicatorView = nil;
	}
	
	self.maxOfItems = 0;
	self.numberOfItems = 0;
	self.showNumber = FALSE;
	
	[super dealloc];
}

#pragma mark @synthesize

@synthesize progressView = _progressView;
@synthesize numberOfItemLabel = _numberOfItemLabel;
@synthesize indicatorView = _indicatorView;
@synthesize maxOfItems = _maxOfItems;
@synthesize numberOfItems = _numberOfItems;
@synthesize showNumber = _showNumber;

@end