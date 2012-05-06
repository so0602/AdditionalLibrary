#import "UITabBarController+Addition.h"

@implementation UITabBarController (Addition)

-(BOOL)tabBarHidden{
	return self.tabBar.hidden;
}

-(void)setTabBarHidden:(BOOL)hidden{
	UIView* view = self.contentView;
	if( hidden ) view.frame = self.view.bounds;
	else view.size = CGSizeMake(self.view.width, self.view.height - self.tabBar.height);
	
	self.tabBar.hidden = hidden;
}

-(UIView*)contentView{
	UIView* contentView = nil;
	for( UIView* view in self.view.subviews ){
		if( [view isKindOfClass:[UITabBar class]] ) continue;
		contentView = view;
		break;
	}
	return contentView;
}

-(void)cubeToIndex:(NSUInteger)index animation:(TabBarCubeAnimation)animation{
	if( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] == NSOrderedAscending ){
		self.selectedIndex = index;
		return;
	}
	
	if( self.selectedIndex == index ){
		self.selectedIndex = index;
		return;
	}
	
	self.view.userInteractionEnabled = FALSE;
	
	UIViewController* currentViewController = self.selectedViewController;
	UIViewController* nextViewController = [self.viewControllers objectAtIndex:index];
	
	nextViewController.view.frame = currentViewController.view.frame;
	
	CGFloat halfWidth = currentViewController.view.bounds.size.width / 2.0;
	CGFloat duration = 0.7;
	CGFloat perspective = -1.0 / 1000.0;
	
	UIView* superview = currentViewController.view.superview;
	CATransformLayer* transformLayer = [[CATransformLayer alloc] init];
	transformLayer.frame = currentViewController.view.layer.bounds;
	
	[currentViewController.view removeFromSuperview];
	[transformLayer addSublayer:currentViewController.view.layer];
	[transformLayer addSublayer:nextViewController.view.layer];
	[superview.layer addSublayer:transformLayer];
	
	[CATransaction begin];
	[CATransaction setDisableActions:TRUE];
	CATransform3D transform = CATransform3DIdentity;
	
	switch( animation ){
		case TabBarCubeAnimationOutside:
			transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
			transform = CATransform3DRotate(transform, self.selectedIndex > index ? -M_PI_2 : M_PI_2, 0, 1, 0);
			transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
			break;
		case TabBarCubeAnimationInside:
			transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
			transform = CATransform3DRotate(transform, self.selectedIndex > index ? M_PI_2 : -M_PI_2, 0, 1, 0);
			transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
			break;
	}
	
	nextViewController.view.layer.transform = transform;
	[CATransaction commit];
	
	[CATransaction begin];
	[CATransaction setCompletionBlock:^(void){
		[nextViewController.view.layer removeFromSuperlayer];
		nextViewController.view.layer.transform = CATransform3DIdentity;
		[currentViewController.view.layer removeFromSuperlayer];
		[superview addSubview:currentViewController.view];
		[transformLayer removeFromSuperlayer];
		self.selectedViewController = nextViewController;
		self.view.userInteractionEnabled = TRUE;
	}];
	
	CABasicAnimation* transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	
	transform = CATransform3DIdentity;
	transform.m34 = perspective;
	transformAnimation.fromValue = [NSValue valueWithCATransform3D:transform];
	
	transform = CATransform3DIdentity;
	transform.m34 = perspective;
	switch( animation ){
		case TabBarCubeAnimationOutside:
			transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
			transform = CATransform3DRotate(transform, self.selectedIndex > index ? M_PI_2 : -M_PI_2, 0, 1, 0);
			transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
			break;
		case TabBarCubeAnimationInside:
			transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
			transform = CATransform3DRotate(transform, self.selectedIndex > index ? -M_PI_2 : M_PI_2, 0, 1, 0);
			transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
			break;
	}
	
	transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
	
	transformAnimation.duration = duration;
	[transformLayer addAnimation:transformAnimation forKey:@"rotate"];
	transformLayer.transform = transform;
	
	[CATransaction commit];
}

-(void)transitionToIndex:(NSUInteger)index{
	if( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] == NSOrderedAscending ){
		self.selectedIndex = index;
		return;
	}
	
	if( self.selectedIndex == index ){
		self.selectedIndex = index;
		return;
	}
	
	UIView* fromView = self.selectedViewController.view;
	UIView* toView = ((UIViewController*)[self.viewControllers objectAtIndex:index]).view;
	
	[UIView transitionFromView:fromView toView:toView duration:0.5 
										 options:(index > self.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown) 
									completion:^(BOOL finished){
										if( finished ) self.selectedIndex = index;
									}];
}

-(void)scrollToIndex:(NSUInteger)index{
	[self scrollToIndex:index delegate:nil stopSelector:nil];
}

-(void)scrollToIndex:(NSUInteger)index delegate:(id)delegate stopSelector:(SEL)stopSelector{
	UIViewController* fromViewController = self.selectedViewController;
	UIViewController* toViewController = [self.viewControllers objectAtIndex:index];
	
	[self tabBarWillChange:index];
	if( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] == NSOrderedAscending ){
		[self tabBarChanging:index animated:FALSE];
		self.selectedIndex = index;
		[self tabBarDidChange:index];
		return;
	}
	
	if( self.selectedIndex == index ){
		[self tabBarChanging:index animated:FALSE];
		self.selectedIndex = index;
		[self tabBarDidChange:index];
		return;
	}
	
	UIView* fromView = fromViewController.view;
	UIView* toView = toViewController.view;
	
	fromView.userInteractionEnabled = toView.userInteractionEnabled = FALSE;
	
	CGRect viewSize = fromView.frame;
	BOOL scrollRight = index > self.selectedIndex;
	
	[fromView.superview addSubview:toView];
	toView.frame = CGRectMake((scrollRight ? 1 : -1) * viewSize.size.width, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
	
	[UIView animateWithDuration:0.3 
									 animations:^{
										 fromView.frame = CGRectMake((scrollRight ? -1 : 1) * viewSize.size.width, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
										 toView.frame = CGRectMake(0, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
										 [self tabBarChanging:index animated:TRUE];
									 } 
									 completion:^(BOOL finished){
										 if( finished ){
											 [fromView removeFromSuperview];
											 self.selectedIndex = index;
											 fromView.userInteractionEnabled = toView.userInteractionEnabled = TRUE;
											 [delegate performSelector:stopSelector];
											 [self tabBarDidChange:index];
										 }
									 }];
}

-(void)tabBarWillChange:(NSUInteger)index{
}

-(void)tabBarChanging:(NSUInteger)index animated:(BOOL)animated{
}

-(void)tabBarDidChange:(NSUInteger)index{
}

@end