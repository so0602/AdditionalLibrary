#import "YTTapDetectingWindow.h"

@interface YTTapDetectingWindow ()

-(void)forwardTap:(id)touch;

@end

@implementation YTTapDetectingWindow

#pragma mark - Override Functions

-(void)sendEvent:(UIEvent*)event{
	[super sendEvent:event];
	
	if( !self.viewToOvserve || !self.controllerThatObserves ) return;
	
	NSSet* touches = [event allTouches];
	if( touches.count != 1 ) return;
	
	UITouch* touch = [touches anyObject];
	if( touch.phase != UITouchPhaseEnded ) return;
	if( ![touch.view isDescendantOfView:self.viewToOvserve] ) return;
	
	CGPoint tapPoint = [touch locationInView:self.viewToOvserve];
	NSArray* pointArray = [NSArray arrayWithObjects:
												 [NSString stringWithFormat:@"%f", tapPoint.x],
												 [NSString stringWithFormat:@"%f", tapPoint.y], nil];
	if( touch.tapCount == 1 ){
		[self performSelector:@selector(forwardTap:) withObject:pointArray afterDelay:0.3];
	}else if( touch.tapCount > 1 ){
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forwardTap:) object:pointArray];
	}
}

#pragma mark Private Functions

-(void)forwardTap:(id)touch{
	[self.controllerThatObserves userDidTapView:touch];
}

#pragma mark - Memory Management

-(void)dealloc{
	[_viewToOvserve release];
	_controllerThatObserves = nil;
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize viewToOvserve = _viewToOvserve;
@synthesize controllerThatObserves = _controllerThatObserves;

@end