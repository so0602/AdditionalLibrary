#import <QuartzCore/QuartzCore.h>

#import "YTGlobalValues.h"
#import "YTDefineValues.h"

#import "NSArray+Addition.h"

@interface UINavigationController (Addition)

-(void)pushViewController:(UIViewController*)viewController animation:(UIViewControllerAnimation)animation;

-(UIViewController*)popViewControllerWithAnimation:(UIViewControllerAnimation)animation;
-(NSArray*)popToViewController:(UIViewController *)viewController animation:(UIViewControllerAnimation)animation;
-(NSArray*)popToRootViewControllerWithAnimation:(UIViewControllerAnimation)animation;

@end