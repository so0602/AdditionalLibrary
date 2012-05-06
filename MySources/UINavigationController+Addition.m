#import "UINavigationController+Addition.h"

@interface UINavigationControllerSingleton : NSObject{
@private
	CALayer* _leftLayer;
	CALayer* _rightLayer;
	CALayer* _nextLayer;
	UIViewController* _nextViewController;
}

+(UINavigationControllerSingleton*)singleton;

@property (nonatomic, retain) CALayer* leftLayer;
@property (nonatomic, retain) CALayer* rightLayer;
@property (nonatomic, retain) CALayer* nextLayer;
@property (nonatomic, retain) UIViewController* nextViewController;

@end

static UINavigationControllerSingleton* _singleton = nil;

@implementation UINavigationControllerSingleton

+(UINavigationControllerSingleton*)singleton{
	if( !_singleton ){
		_singleton = [[UINavigationControllerSingleton alloc] init];
	}
	return _singleton;
}

#pragma mark - Memory Management

-(void)dealloc{
	[_leftLayer release];
	[_rightLayer release];
	[_nextLayer release];
	[_nextViewController release];
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize leftLayer = _leftLayer;
@synthesize rightLayer = _rightLayer;
@synthesize nextLayer = _nextLayer;
@synthesize nextViewController = _nextViewController;

@end

@interface UINavigationController ()

+(CGImageRef)clipImageFromLayer:(CALayer*)layer size:(CGSize)size offsetX:(CGFloat)offsetX;
-(CAAnimation*)openDoorAnimationWithRotationDegree:(CGFloat)degree;
-(CAAnimation*)closeDoorAnimationWithRotationDegree:(CGFloat)degree;
-(CAAnimation*)zoomInAnimation;
-(CAAnimation*)zoomOutAnimation;

-(NSArray*)viewControllersBetweenViewController:(UIViewController*)viewController nextViewController:(UIViewController*)nextViewController;

-(NSArray*)openDoorWithViewController:(UIViewController*)viewController nextViewController:(UIViewController*)nextViewController;
-(NSArray*)closeDoorWithViewController:(UIViewController*)viewController nextViewController:(UIViewController*)nextViewController;

@end

@implementation UINavigationController (Addition)

-(void)pushViewController:(UIViewController*)viewController animation:(UIViewControllerAnimation)animation{
	switch( animation ){
		case UIViewControllerAnimationNormal:
			[self pushViewController:viewController animated:TRUE];
			break;
		case UIViewControllerAnimationOpenDoor:
			[self openDoorWithViewController:[self.viewControllers lastObject] nextViewController:viewController];
			break;
		case UIViewControllerAnimationCloseDoor:
			[self closeDoorWithViewController:[self.viewControllers lastObject] nextViewController:viewController];
			break;
		default:
			[self pushViewController:viewController animation:UIViewControllerAnimationNormal];
			break;
	}
}

-(UIViewController*)popViewControllerWithAnimation:(UIViewControllerAnimation)animation{
	if( self.viewControllers.count < 2 ) return nil;
	return [[self popToViewController:[self.viewControllers lastSecondObject] animation:animation] lastObject];
}

-(NSArray*)popToViewController:(UIViewController *)viewController animation:(UIViewControllerAnimation)animation{
	switch( animation ){
		case UIViewControllerAnimationNormal:
			return [self popToViewController:viewController animated:TRUE];
			break;
		case UIViewControllerAnimationOpenDoor:
			return [self openDoorWithViewController:[self.viewControllers lastObject] nextViewController:viewController];
			break;
		case UIViewControllerAnimationCloseDoor:
			return [self closeDoorWithViewController:[self.viewControllers lastObject] nextViewController:viewController];
			break;
		default:
			return [self popToViewController:viewController animation:UIViewControllerAnimationNormal];
			break;
	}
	return nil;
}

-(NSArray*)popToRootViewControllerWithAnimation:(UIViewControllerAnimation)animation{
	if( self.viewControllers.count == 1 ) return nil;
	return [self popToViewController:[self.viewControllers firstObject] animation:animation];
}

#pragma mark - Private Functions

+(CGImageRef)clipImageFromLayer:(CALayer*)layer size:(CGSize)size offsetX:(CGFloat)offsetX{
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, offsetX, 0.0f);
	[layer renderInContext:context];
	UIImage* snapshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return snapshot.CGImage;
}

-(CAAnimation*)openDoorAnimationWithRotationDegree:(CGFloat)degree{
	CAAnimationGroup* animGroup = [CAAnimationGroup animation];
	
	CABasicAnimation* openAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	openAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	openAnim.fromValue = [NSNumber numberWithFloat:0.0f];
	openAnim.toValue = [NSNumber numberWithFloat:DegreesToRadians(degree)];
	
	CABasicAnimation* zoomInAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
	zoomInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	zoomInAnim.fromValue = [NSNumber numberWithFloat:0.0f];
	zoomInAnim.toValue = [NSNumber numberWithFloat:300.0f];
	
	animGroup.animations = [NSArray arrayWithObjects:openAnim, zoomInAnim, nil];
	animGroup.duration = 1.5f;
	
	return animGroup;
}

-(CAAnimation*)closeDoorAnimationWithRotationDegree:(CGFloat)degree{
	CAAnimationGroup* animGroup = [CAAnimationGroup animation];
	
	CABasicAnimation* closeAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	closeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	closeAnim.fromValue = [NSNumber numberWithFloat:DegreesToRadians(degree)];
	closeAnim.toValue = [NSNumber numberWithFloat:0.0f];
	
	CABasicAnimation* zoomOutAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
	zoomOutAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	zoomOutAnim.fromValue = [NSNumber numberWithFloat:300.0f];
	zoomOutAnim.toValue = [NSNumber numberWithFloat:0.0f];
	
	animGroup.animations = [NSArray arrayWithObjects:closeAnim, zoomOutAnim, nil];
	animGroup.duration = 1.5f;
	
	return animGroup;
}

-(CAAnimation*)zoomInAnimation{
	CAAnimationGroup* animGroup = [CAAnimationGroup animation];
	
	CABasicAnimation* zoomInAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
	zoomInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	zoomInAnim.fromValue = [NSNumber numberWithFloat:-1000.0f];
	zoomInAnim.toValue = [NSNumber numberWithFloat:0.0f];
	
	CABasicAnimation* fadeInAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeInAnim.fromValue = [NSNumber numberWithFloat:0.0f];
	fadeInAnim.toValue = [NSNumber numberWithFloat:1.0f];
	
	animGroup.animations = [NSArray arrayWithObjects:zoomInAnim, fadeInAnim, nil];
	animGroup.duration = 1.5f;
	
	return animGroup;
}

-(CAAnimation*)zoomOutAnimation{
	CAAnimationGroup* animGroup = [CAAnimationGroup animation];
	
	CABasicAnimation* zoomOutAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
	zoomOutAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	zoomOutAnim.fromValue = [NSNumber numberWithFloat:0.0f];
	zoomOutAnim.toValue = [NSNumber numberWithFloat:-1000.0f];
	
	CABasicAnimation* fadeOutAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeOutAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeOutAnim.fromValue = [NSNumber numberWithFloat:1.0f];
	fadeOutAnim.toValue = [NSNumber numberWithFloat:0.0f];
	
	animGroup.animations = [NSArray arrayWithObjects:zoomOutAnim, fadeOutAnim, nil];
	animGroup.duration = 1.5f;
	
	return animGroup;
}

-(NSArray*)viewControllersBetweenViewController:(UIViewController*)preViewController nextViewController:(UIViewController*)viewController{
	NSArray* viewControllers = [NSArray arrayWithArray:self.viewControllers];
	NSInteger preIdx = [viewControllers indexOfObject:preViewController];
	NSInteger nextIdx = [viewControllers indexOfObject:viewController];
	if( preIdx == NSNotFound || nextIdx == NSNotFound ){
		viewControllers = nil;
	}else{
		NSInteger first = preIdx < nextIdx ? preIdx : nextIdx;
		NSInteger second = preIdx < nextIdx ? nextIdx : preIdx;
		viewControllers = [viewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(first + 1, second - first)]];
	}
	return viewControllers;
}

-(NSArray*)openDoorWithViewController:(UIViewController*)preViewController nextViewController:(UIViewController*)viewController{
	NSArray* viewControllers = [self viewControllersBetweenViewController:preViewController nextViewController:viewController];
	
	[UINavigationControllerSingleton singleton].nextViewController = viewController;
	
	CGRect frame = [preViewController.view convertRect:preViewController.view.frame toView:self.view];
	CGSize screenSize = frame.size;
	CGPoint topLeft = frame.origin;
	CGRect leftDoorRect = CGRectMake(topLeft.x, topLeft.y, screenSize.width / 2.0f, screenSize.height);
	CGRect rightDoorRect = CGRectMake(screenSize.width / 2.0f + topLeft.x, topLeft.y, screenSize.width / 2.0f, screenSize.height);
	
	CALayer* leftLayer = [CALayer layer];
	leftLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
	leftLayer.frame = leftDoorRect;
	CATransform3D leftTransform = leftLayer.transform;
	leftTransform.m34 = 1.0f / -420.0f;
	leftLayer.transform = leftTransform;
	leftLayer.shadowOffset = CGSizeMake(5.0f, 5.0f);
	[UINavigationControllerSingleton singleton].leftLayer = leftLayer;
	
	CALayer* rightLayer = [CALayer layer];
	rightLayer.anchorPoint = CGPointMake(1.0f, 0.5f);
	rightLayer.frame = rightDoorRect;
	CATransform3D rightTransform = rightLayer.transform;
	rightTransform.m34 = 1.0f / -420.0f;
	rightLayer.transform = rightTransform;
	rightLayer.shadowOffset = CGSizeMake(5.0f, 5.0f);
	[UINavigationControllerSingleton singleton].rightLayer = rightLayer;
	
	CALayer* nextLayer = [CALayer layer];
	nextLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
	nextLayer.frame = CGRectMake(topLeft.x, topLeft.y, screenSize.width, screenSize.height);
	CATransform3D nextTransform = nextLayer.transform;
	nextTransform.m34 = 1.0f / -420.0f;
	nextLayer.transform = nextTransform;
	[UINavigationControllerSingleton singleton].nextLayer = nextLayer;
	
	leftLayer.contents = (id)[UINavigationController clipImageFromLayer:preViewController.view.layer size:leftDoorRect.size offsetX:0.0f];
	
	rightLayer.contents = (id)[UINavigationController clipImageFromLayer:preViewController.view.layer size:rightDoorRect.size offsetX:-leftDoorRect.size.width];
	
	nextLayer.contents = (id)[UINavigationController clipImageFromLayer:viewController.view.layer size:screenSize offsetX:0.0f];
	
	[self.view.layer addSublayer:nextLayer];
	[self.view.layer addSublayer:leftLayer];
	[self.view.layer addSublayer:rightLayer];
	
	CAAnimation* leftDoorAnimation = [self openDoorAnimationWithRotationDegree:90.0f];
	[leftLayer addAnimation:leftDoorAnimation forKey:@"doorAnimationStarted"];
	
	CAAnimation* rightDoorAnimation = [self openDoorAnimationWithRotationDegree:-90.0f];
	[rightLayer addAnimation:rightDoorAnimation forKey:@"doorAnimationStarted"];
	
	CAAnimation* nextViewAnimation = [self zoomInAnimation];
	nextViewAnimation.delegate = self;
	[nextLayer addAnimation:nextViewAnimation forKey:@"nextViewAnimationStarted"];
	
	[preViewController.view removeFromSuperview];
	
	return viewControllers;
}

-(NSArray*)closeDoorWithViewController:(UIViewController*)preViewController nextViewController:(UIViewController*)viewController{
	NSArray* viewControllers = [self viewControllersBetweenViewController:preViewController nextViewController:viewController];
	
	[UINavigationControllerSingleton singleton].nextViewController = viewController;
	
	CGRect frame = [preViewController.view convertRect:preViewController.view.frame toView:self.view];
	CGSize screenSize = frame.size;
	CGPoint topLeft = frame.origin;
	CGRect leftDoorRect = CGRectMake(topLeft.x, topLeft.y, screenSize.width / 2.0f, screenSize.height);
	CGRect rightDoorRect = CGRectMake(screenSize.width / 2.0f + topLeft.x, topLeft.y, screenSize.width / 2.0f, screenSize.height);
	
	CALayer* leftLayer = [CALayer layer];
	leftLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
	leftLayer.frame = leftDoorRect;
	CATransform3D leftTransform = leftLayer.transform;
//	leftTransform.m34 = 1.0f / -420.0f;
	leftLayer.transform = leftTransform;
	leftLayer.shadowOffset = CGSizeMake(5.0f, 5.0f);
	[UINavigationControllerSingleton singleton].leftLayer = leftLayer;
	
	CALayer* rightLayer = [CALayer layer];
	rightLayer.anchorPoint = CGPointMake(1.0f, 0.5f);
	rightLayer.frame = rightDoorRect;
	CATransform3D rightTransform = rightLayer.transform;
//	rightTransform.m34 = 1.0f / -420.0f;
	rightLayer.transform = rightTransform;
	rightLayer.shadowOffset = CGSizeMake(5.0f, 5.0f);
	[UINavigationControllerSingleton singleton].rightLayer = rightLayer;
	
	CALayer* nextLayer = [CALayer layer];
	nextLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
	nextLayer.frame = CGRectMake(topLeft.x, topLeft.y, screenSize.width, screenSize.height);
	CATransform3D nextTransform = nextLayer.transform;
	nextTransform.m34 = 1.0f / -420.0f;
	nextLayer.transform = nextTransform;
	[UINavigationControllerSingleton singleton].nextLayer = nextLayer;
	
	leftLayer.contents = (id)[UINavigationController clipImageFromLayer:viewController.view.layer size:leftDoorRect.size offsetX:0.0f];
	
	rightLayer.contents = (id)[UINavigationController clipImageFromLayer:viewController.view.layer size:rightDoorRect.size offsetX:-leftDoorRect.size.width];
	
	nextLayer.contents = (id)[UINavigationController clipImageFromLayer:preViewController.view.layer size:screenSize offsetX:0.0f];
	
	[self.view.layer addSublayer:nextLayer];
	[self.view.layer addSublayer:leftLayer];
	[self.view.layer addSublayer:rightLayer];
	
	CAAnimation* leftDoorAnimation = [self closeDoorAnimationWithRotationDegree:90.0f];
	[leftLayer addAnimation:leftDoorAnimation forKey:@"doorAnimationStarted"];
	
	CAAnimation* rightDoorAnimation = [self closeDoorAnimationWithRotationDegree:-90.0f];
	[rightLayer addAnimation:rightDoorAnimation forKey:@"doorAnimationStarted"];
	
	CAAnimation* nextViewAnimation = [self zoomOutAnimation];
	nextViewAnimation.delegate = self;
	[nextLayer addAnimation:nextViewAnimation forKey:@"nextViewAnimationStarted"];
	
	[preViewController.view removeFromSuperview];
	
	return viewControllers;
}

#pragma mark - Animation Delegate

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	if( flag ){
		UINavigationControllerSingleton* singleton = [UINavigationControllerSingleton singleton];
		[singleton.leftLayer removeFromSuperlayer];
		singleton.leftLayer = nil;
		[singleton.rightLayer removeFromSuperlayer];
		singleton.rightLayer = nil;
		[singleton.nextLayer removeFromSuperlayer];
		singleton.nextLayer = nil;
		NSInteger index = [self.viewControllers indexOfObject:singleton.nextViewController];
		if( index == NSNotFound ){
			[self pushViewController:singleton.nextViewController animated:FALSE];
		}else{
			[self popToViewController:singleton.nextViewController animated:FALSE];
		}
		
		singleton.nextViewController = nil;
	}
}

@end