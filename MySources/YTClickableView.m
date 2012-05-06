#import "YTClickableView.h"

@interface YTClickableView ()

@property (nonatomic, retain) id<YTClickableViewDelegate> delegate;

@end

@implementation YTClickableView

@synthesize delegate = _delegate;

-(id)initWithDelegate:(id<YTClickableViewDelegate>)delegate{
	return [self initWithFrame:CGRectZero delegate:delegate];
}

-(id)initWithFrame:(CGRect)frame delegate:(id<YTClickableViewDelegate>)delegate{
	if( self = [super initWithFrame:frame] ){
		self.delegate = delegate;
	}
	return self;
}

#pragma mark Touches Callback

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	if( RespondsToSelector(self.delegate, @selector(clickableView:touchBeganAtPoint:atView:)) ){
		UITouch* touch = [[event allTouches] anyObject];
		CGPoint point = [touch locationInView:self.superview];
		[self.delegate clickableView:self touchBeganAtPoint:point atView:self.superview];
	}
}

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event{
	if( RespondsToSelector(self.delegate, @selector(clickableView:touchCancelledAtPoint:atView:)) ){
		UITouch* touch = [[event allTouches] anyObject];
		CGPoint point = [touch locationInView:self.superview];
		[self.delegate clickableView:self touchCancelledAtPoint:point atView:self.superview];
	}
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
	if( RespondsToSelector(self.delegate, @selector(clickableView:touchEndedAtPoint:atView:)) ){
		UITouch* touch = [[event allTouches] anyObject];
		CGPoint point = [touch locationInView:self.superview];
		[self.delegate clickableView:self touchEndedAtPoint:point atView:self.superview];
	}
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
	if( RespondsToSelector(self.delegate, @selector(clickableView:touchMovedAtPoint:toPoint:atView:)) ){
		UITouch* touch = [[event allTouches] anyObject];
		CGPoint atPoint = [touch previousLocationInView:self.superview];
		CGPoint toPoint = [touch locationInView:self.superview];
		[self.delegate clickableView:self touchMovedAtPoint:atPoint toPoint:toPoint atView:self.superview];
	}
}

@end