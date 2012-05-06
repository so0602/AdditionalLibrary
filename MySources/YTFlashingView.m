#import "YTFlashingView.h"

@interface YTFlashingView ()

@property (nonatomic, getter=isFlashing, readwrite) BOOL flashing;
@property (nonatomic) NSInteger currentRepeatCount;

-(void)flash;

@end

@implementation YTFlashingView

-(void)startFlashing{
	if( !self.flashing ){
		self.flashing = TRUE;
		self.currentRepeatCount = 0;
		[self flash];
	}
}

-(void)stopFlashing{
	self.flashing = FALSE;
}

#pragma mark Override Functions

-(id)initWithFrame:(CGRect)frame{
	if( self = [super initWithFrame:frame] ){
		self.duration = 1.0f;
		self.flashingRepeatCount = 0;
	}
	return self;
}

#pragma mark Private Functions

-(void)flash{
	if( !self.flashing ) return;
	
	if( ++_currentRepeatCount > self.flashingRepeatCount && self.flashingRepeatCount > 0 ){
		self.flashing = FALSE;
		return;
	}
	
	if( self.alpha == 1 ) [YTAnimation hiddenView:self duration:self.duration delegate:self stopSelector:@selector(flash)];
	else if( self.alpha == 0 ) [YTAnimation showView:self duration:self.duration delegate:self stopSelector:@selector(flash)];
	else self.flashing = FALSE;
}

#pragma mark Memory Management

-(void)dealloc{
	self.flashing = FALSE;
	self.duration = 0.0f;
	self.flashingRepeatCount = 0;
	self.currentRepeatCount = 0;
	
	[super dealloc];
}

#pragma mark @synthesize

@synthesize flashing = _flashing;
@synthesize duration = _duration;
@synthesize flashingRepeatCount = _flashingRepeatCount;
@synthesize currentRepeatCount = _currentRepeatCount;

@end