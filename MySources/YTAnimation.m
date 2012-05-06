#import "YTAnimation.h"

@interface YTAnimation ()

+(void)createAnimation:(NSString*)animID context:(void*)context duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector;
+(void)transitionAnimation:(UIViewAnimationTransition)animationTransition view:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context;

@end

@implementation YTAnimation

+(void)moveView:(UIView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration{
	[self moveView:view toPoint:point alpha:view.alpha duration:duration delegate:nil animID:nil context:nil];
}

+(void)moveView:(UIView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self moveView:view toPoint:point alpha:view.alpha duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)moveView:(UIView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self moveView:view toPoint:point alpha:view.alpha duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)moveView:(UIView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[self moveView:view toPoint:point alpha:view.alpha duration:duration delegate:delegate stopSelector:stopSelector animID:animID context:context];
}

+(void)moveView:(UIView*)view toPoint:(CGPoint)point alpha:(CGFloat)alpha duration:(NSTimeInterval)duration{
	[self moveView:view toPoint:point alpha:alpha duration:duration delegate:nil animID:nil context:nil];
}

+(void)moveView:(UIView*)view toPoint:(CGPoint)point alpha:(CGFloat)alpha duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self moveView:view toPoint:point alpha:alpha duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)moveView:(UIView*)view toPoint:(CGPoint)point alpha:(CGFloat)alpha duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self moveView:view toPoint:point alpha:alpha duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)moveView:(UIView*)view toPoint:(CGPoint)point alpha:(CGFloat)alpha duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	view.frame = CGRectMake(point.x, point.y, view.frame.size.width, view.frame.size.height);
	view.alpha = alpha;
	[UIView commitAnimations];
}

+(void)moveViews:(NSArray*)views offset:(CGPoint)offset duration:(NSTimeInterval)duration{
	[self moveViews:views offset:offset duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)moveViews:(NSArray*)views offset:(CGPoint)offset duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self moveViews:views offset:offset duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)moveViews:(NSArray*)views offset:(CGPoint)offset duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self moveViews:views offset:offset duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)moveViews:(NSArray*)views offset:(CGPoint)offset duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	for( UIView* view in views ) view.frame = CGRectMake(view.frame.origin.x + offset.x, view.frame.origin.y + offset.y, view.frame.size.width, view.frame.size.height);
	[UIView commitAnimations];
}

+(void)moveContentOffsetOfView:(UIScrollView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration{
	[self moveContentOffsetOfView:view toPoint:point duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)moveContentOffsetOfView:(UIScrollView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self moveContentOffsetOfView:view toPoint:point duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)moveContentOffsetOfView:(UIScrollView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self moveContentOffsetOfView:view toPoint:point duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)moveContentOffsetOfView:(UIScrollView*)view toPoint:(CGPoint)point duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	view.contentOffset = point;
	[UIView commitAnimations];
}

+(void)hiddenView:(UIView*)view duration:(NSTimeInterval)duration{
	[self hiddenView:view duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)hiddenView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self hiddenView:view duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)hiddenView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self hiddenView:view duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)hiddenView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	view.alpha = 0.0f;
	[UIView commitAnimations];
}

+(void)hiddenViews:(NSArray*)views duration:(NSTimeInterval)duration{
	[self hiddenViews:views duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)hiddenViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self hiddenViews:views duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)hiddenViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self hiddenViews:views duration:duration delegate:nil stopSelector:stopSelector animID:nil context:nil];
}

+(void)hiddenViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	for( UIView* view in views ) view.alpha = 0.0f;
	[UIView commitAnimations];
}

+(void)showView:(UIView*)view duration:(NSTimeInterval)duration{
	[self showView:view duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)showView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self showView:view duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)showView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self showView:view duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)showView:(UIView*)view duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	view.alpha = 1.0f;
	[UIView commitAnimations];
}

+(void)showViews:(NSArray*)views duration:(NSTimeInterval)duration{
	[self showViews:views duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)showViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self showViews:views duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)showViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self showViews:views duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)showViews:(NSArray*)views duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	for( UIView* view in views ) view.alpha = 1.0f;
	[UIView commitAnimations];
}

+(void)scaleView:(UIView*)view toSize:(CGSize)size duration:(NSTimeInterval)duration{
	[self scaleView:view toSize:size duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)scaleView:(UIView*)view toSize:(CGSize)size duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self scaleView:view toSize:size duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)scaleView:(UIView*)view toSize:(CGSize)size duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self scaleView:view toSize:size duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)scaleView:(UIView*)view toSize:(CGSize)size duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, size.width, size.height);
	[UIView commitAnimations];
}

+(void)resetView:(UIView*)view toFrame:(CGRect)frame duration:(NSTimeInterval)duration{
	[self resetView:view toFrame:frame duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)resetView:(UIView*)view toFrame:(CGRect)frame duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self resetView:view toFrame:frame duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)resetView:(UIView*)view toFrame:(CGRect)frame duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self resetView:view toFrame:frame duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)resetView:(UIView*)view toFrame:(CGRect)frame duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	view.frame = frame;
	[UIView commitAnimations];
}

+(void)scaleViews:(NSArray*)views scaleFactor:(float)scaleFactor duration:(NSTimeInterval)duration{
	[self scaleViews:views scaleFactor:scaleFactor duration:duration delegate:nil stopSelector:nil animID:nil context:nil];
}

+(void)scaleViews:(NSArray*)views scaleFactor:(float)scaleFactor duration:(NSTimeInterval)duration delegate:(id)delegate animID:(NSString*)animID context:(void*)context{
	[self scaleViews:views scaleFactor:scaleFactor duration:duration delegate:delegate stopSelector:nil animID:animID context:context];
}

+(void)scaleViews:(NSArray*)views scaleFactor:(float)scaleFactor duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[self scaleViews:views scaleFactor:scaleFactor duration:duration delegate:delegate stopSelector:stopSelector animID:nil context:nil];
}

+(void)scaleViews:(NSArray*)views scaleFactor:(float)scaleFactor duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[YTAnimation createAnimation:animID context:context duration:duration delegate:delegate stopSelector:stopSelector];
	for( UIView* view in views ) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width * scaleFactor, view.frame.size.height * scaleFactor);
	[UIView commitAnimations];
}

+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration{
	[self transitionCurlUp:view cache:cache duration:duration delegate:nil selector:nil stopSelector:nil animID:nil context:nil];
}

+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector{
	[self transitionCurlUp:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:nil animID:nil context:nil];
}

+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector{
	[self transitionCurlUp:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:stopSelector animID:nil context:nil];
}

+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector animID:(NSString*)animID context:(void*)context{
	[self transitionCurlUp:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:nil animID:animID context:context];
}

+(void)transitionCurlUp:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[self transitionAnimation:UIViewAnimationTransitionCurlUp view:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:stopSelector animID:animID context:context];
}

+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration{
	[self transitionCurlDown:view cache:cache duration:duration delegate:nil selector:nil stopSelector:nil animID:nil context:nil];
}

+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector{
	[self transitionCurlDown:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:nil animID:nil context:nil];
}

+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector{
	[self transitionCurlDown:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:stopSelector animID:nil context:nil];
}

+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector animID:(NSString*)animID context:(void*)context{
	[self transitionCurlDown:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:nil animID:animID context:context];
}

+(void)transitionCurlDown:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[self transitionAnimation:UIViewAnimationTransitionCurlDown view:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:stopSelector animID:animID context:context];
}

+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration{
	[self transitionFlipFromLeft:view cache:cache duration:duration delegate:nil selector:nil stopSelector:nil animID:nil context:nil];
}

+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector{
	[self transitionFlipFromLeft:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:nil animID:nil context:nil];
}

+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector{
	[self transitionFlipFromLeft:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:stopSelector animID:nil context:nil];
}

+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector animID:(NSString*)animID context:(void*)context{
	[self transitionFlipFromLeft:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:nil animID:animID context:context];
}

+(void)transitionFlipFromLeft:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[self transitionAnimation:UIViewAnimationTransitionFlipFromLeft view:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:stopSelector animID:animID context:context];
}

+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration{
	[self transitionFlipFromRight:view cache:cache duration:duration delegate:nil selector:nil stopSelector:nil animID:nil context:nil];
}

+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector{
	[self transitionFlipFromRight:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:nil animID:nil context:nil];
}

+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector{
	[self transitionFlipFromRight:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:stopSelector animID:nil context:nil];
}

+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector animID:(NSString*)animID context:(void*)context{
	[self transitionFlipFromRight:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:nil animID:animID context:context];
}

+(void)transitionFlipFromRight:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[self transitionAnimation:UIViewAnimationTransitionFlipFromRight view:view cache:cache duration:duration delegate:delegate selector:selector stopSelector:stopSelector animID:animID context:context];
}

#pragma mark Private Functions

+(void)createAnimation:(NSString*)animID context:(void*)context duration:(NSTimeInterval)duration delegate:(id)delegate stopSelector:(SEL)stopSelector{
	[UIView beginAnimations:animID context:context];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationBeginsFromCurrentState:TRUE];
	[UIView setAnimationDelegate:delegate];
	[UIView setAnimationDidStopSelector:stopSelector];
}

+(void)transitionAnimation:(UIViewAnimationTransition)animationTransition view:(UIView*)view cache:(BOOL)cache duration:(NSTimeInterval)duration delegate:(id)delegate selector:(SEL)selector stopSelector:(SEL)stopSelector animID:(NSString*)animID context:(void*)context{
	[UIView beginAnimations:animID context:context];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationTransition:animationTransition forView:view cache:cache];
	[UIView setAnimationBeginsFromCurrentState:TRUE];
	if( delegate ){
		[UIView setAnimationDelegate:delegate];
		if( selector ) [delegate performSelector:selector];
		[UIView setAnimationDidStopSelector:stopSelector];
	}
	[UIView commitAnimations];
}

@end